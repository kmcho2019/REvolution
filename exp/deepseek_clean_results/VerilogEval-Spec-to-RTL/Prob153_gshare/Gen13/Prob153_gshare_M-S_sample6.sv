module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // 7-bit global history register
    reg [6:0] ghr;
    // 128-entry pattern history table (2-bit saturating counters)
    reg [1:0] pht [0:127];

    // Prediction is combinational
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken
            end
        end else begin
            // Priority: training over prediction
            if (train_valid) begin
                // Update PHT counter with saturation
                case ({pht[train_index], train_taken})
                    3'b000: pht[train_index] <= 2'b00;
                    3'b001: pht[train_index] <= 2'b01;
                    3'b010: pht[train_index] <= 2'b01;
                    3'b011: pht[train_index] <= 2'b10;
                    3'b100: pht[train_index] <= 2'b01;
                    3'b101: pht[train_index] <= 2'b10;
                    3'b110: pht[train_index] <= 2'b10;
                    3'b111: pht[train_index] <= 2'b11;
                endcase

                // Update GHR for misprediction recovery
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end else if (predict_valid) begin
                    ghr <= {ghr[5:0], predict_taken};
                end
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule