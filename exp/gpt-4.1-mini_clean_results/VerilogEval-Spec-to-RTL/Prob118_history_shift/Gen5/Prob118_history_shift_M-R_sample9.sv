module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    reg [31:0] next_predict_history;
    wire       update_enable;

    // Update enabled if either misprediction rollback or prediction shift
    assign update_enable = train_mispredicted | predict_valid;

    // Combinational next state logic with priority to misprediction rollback
    always @(*) begin
        if (train_mispredicted)
            // Rollback by shifting train_history left by 1 and inserting train_taken at LSB
            next_predict_history = {train_history[30:0], train_taken};
        else if (predict_valid)
            // Shift predict_history left by 1 and insert predict_taken at LSB
            next_predict_history = {predict_history[30:0], predict_taken};
        else
            next_predict_history = predict_history; // hold state
    end

    // Sequential block with asynchronous reset and clock enable for power saving
    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else if (update_enable)
            predict_history <= next_predict_history;
    end

endmodule