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

    // Enable update when either rollback or prediction shift required
    assign update_enable = train_mispredicted | predict_valid;

    // Combinational next state logic with priority to rollback
    always @(*) begin
        if (train_mispredicted)
            // rollback: train_history[30:0] concat train_taken at LSB
            next_predict_history = {train_history[30:0], train_taken};
        else if (predict_valid)
            // shift in prediction at LSB
            next_predict_history = {predict_history[30:0], predict_taken};
        else
            next_predict_history = predict_history;
    end

    // Sequential logic with asynchronous active-high reset and clock enable
    always @(posedge clk or posedge areset) begin
        if (areset)
            predict_history <= 32'b0;
        else if (update_enable)
            predict_history <= next_predict_history;
        // else hold current value to avoid toggling
    end

endmodule