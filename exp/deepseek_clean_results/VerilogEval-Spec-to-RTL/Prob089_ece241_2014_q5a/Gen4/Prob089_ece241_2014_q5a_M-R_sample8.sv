module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State definitions
    parameter STATE_PASS = 1'b0;
    parameter STATE_INVERT = 1'b1;
    
    reg state;
    wire next_state;

    // Next state logic (combinational)
    assign next_state = (state == STATE_PASS) ? (x ? STATE_INVERT : STATE_PASS) : STATE_INVERT;

    // State storage (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_PASS;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (combinational)
    assign z = (state == STATE_PASS) ? x : ~x;

endmodule