module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history_reg;
    wire [31:0] next_history;
    wire update_en;

    // Clock gating control
    assign update_en = areset | train_mispredicted | predict_valid;

    // Next state logic with priority encoding
    always @(*) begin
        casex ({areset, train_mispredicted, predict_valid})
            3'b1??:  next_history = 32'b0;                // Reset highest priority
            3'b01?:  next_history = {train_history[30:0], train_taken};  // Misprediction
            3'b001:  next_history = {history_reg[30:0], predict_taken};  // Prediction
            default: next_history = history_reg;          // Hold value
        endcase
    end

    // Register update with clock gating
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else if (update_en) begin
            history_reg <= next_history;
        end
    end

    assign predict_history = history_reg;

endmodule