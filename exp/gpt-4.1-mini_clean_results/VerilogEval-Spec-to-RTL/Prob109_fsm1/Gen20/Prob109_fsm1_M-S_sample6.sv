module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;            // state B
        else if (state)
            state <= in ? 1'b1 : 1'b0; // B: in=1->B, in=0->A
        else
            state <= in ? 1'b0 : 1'b1; // A: in=1->A, in=0->B
    end

    assign out = state;

endmodule