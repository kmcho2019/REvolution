module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output [31:0]  predict_history
);

    reg [31:0] history;
    reg [31:0] next_history;

    // Signals for update and operation modes
    wire load = train_mispredicted;
    wire shift = !train_mispredicted && predict_valid;
    wire update_enable = load | shift;

    // Correct rollback: train_history concatenated with train_taken (youngest bit at LSB)
    wire [31:0] rollback_value = {train_history[30:0], train_taken};
    wire [31:0] shifted_value  = {history[30:0], predict_taken};

    // Next state logic: combinational and prioritized
    always @(*) begin
        if (load)
            next_history = rollback_value;
        else if (shift)
            next_history = shifted_value;
        else
            next_history = history;
    end

    // Sequential block with asynchronous active-high reset and clock enable
    always @(posedge clk or posedge areset) begin
        if (areset)
            history <= 32'b0;
        else if (update_enable)
            history <= next_history;
        // else hold history (avoid unnecessary toggling)
    end

    assign predict_history = history;

endmodule