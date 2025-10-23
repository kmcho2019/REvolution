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

    // Pattern History Table (128 entries of 2-bit counters)
    reg [1:0] pht [0:127];
    // Global History Register
    reg [6:0] ghr;

    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1]; // MSB determines taken/not
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly taken (2'b10)
            for (int i = 0; i < 128; i++) begin
                pht[i] <= 2'b10;
            end
            ghr <= 7'b0;
        end else begin
            // PHT update (training has priority)
            if (train_valid) begin
                case (pht[train_index])
                    2'b00: pht[train_index] <= train_taken ? 2'b01 : 2'b00;
                    2'b01: pht[train_index] <= train_taken ? 2'b10 : 2'b00;
                    2'b10: pht[train_index] <= train_taken ? 2'b11 : 2'b01;
                    2'b11: pht[train_index] <= train_taken ? 2'b11 : 2'b10;
                endcase
            end

            // GHR update (misprediction recovery has highest priority)
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end else if (train_valid) begin
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule