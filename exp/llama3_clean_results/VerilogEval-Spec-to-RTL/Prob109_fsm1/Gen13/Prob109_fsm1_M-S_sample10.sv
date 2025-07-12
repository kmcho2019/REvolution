module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    logic state; // Current state (A=0, B=1)

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) state <= 1'b1;
        else state <= in ? state : !state;
    end

    // Directly assign output based on the state
    assign out = state;

endmodule