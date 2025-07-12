module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1;         // reset to state B (1)
        else if (out)
            out <= in ? 1'b1 : 1'b0;  // B->B on 1, B->A on 0
        else
            out <= in ? 1'b0 : 1'b1;  // A->A on 1, A->B on 0
    end

endmodule