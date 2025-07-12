module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;            // Reset to B
        else
            state <= state ^ ~in;     // next state logic
    end

    assign out = state;               // output is 1 in B, 0 in A

endmodule