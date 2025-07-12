module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history_reg;
    reg [31:0] next_history;
    wire       update_enable;

    // Determine when update is required
    assign update_enable = train_mispredicted | predict_valid;

    // Combinational logic for next state with priority: rollback > prediction shift
    always @(*) begin
        if (train_mispredicted)
            // Rollback: take lower 31 bits of train_history and concat train_taken LSB at bit 0
            next_history = {train_history[30:0], train_taken};
        else if (predict_valid)
            // Shift in predicted taken bit at LSB
            next_history = {history_reg[30:0], predict_taken};
        else
            // No update; hold current history
            next_history = history_reg;
    end

    // Sequential logic: async active-high reset, clock enable to reduce toggling
    always @(posedge clk or posedge areset) begin
        if (areset)
            history_reg <= 32'b0;
        else if (update_enable)
            history_reg <= next_history;
        // else retain old state
    end

    // Output reflects current history register value directly
    assign predict_history = history_reg;

endmodule