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

    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;

    // Training logic
    wire [6:0] train_index = train_pc ^ train_history;
    reg [1:0] updated_counter;

    // Update PHT on training
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and PHT
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;  // Weakly not-taken initial state
            end
        end else begin
            if (train_valid) begin
                // Update PHT entry
                case (pht[train_index])
                    2'b00: updated_counter = train_taken ? 2'b01 : 2'b00;
                    2'b01: updated_counter = train_taken ? 2'b10 : 2'b00;
                    2'b10: updated_counter = train_taken ? 2'b11 : 2'b01;
                    2'b11: updated_counter = train_taken ? 2'b11 : 2'b10;
                endcase
                pht[train_index] <= updated_counter;

                // Update GHR if not mispredicted (misprediction recovers history)
                if (!train_mispredicted) begin
                    ghr <= {ghr[5:0], train_taken};
                end
            end else if (predict_valid) begin
                // Update GHR with prediction (only if no training)
                ghr <= {ghr[5:0], predict_taken};
            end

            // Handle misprediction recovery (overrides any prediction update)
            if (train_valid && train_mispredicted) begin
                ghr <= {train_history[5:0], train_taken};
            end
        end
    end

endmodule