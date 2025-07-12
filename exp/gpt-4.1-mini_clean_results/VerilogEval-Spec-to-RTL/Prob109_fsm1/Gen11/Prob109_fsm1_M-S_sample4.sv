module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1;         // reset to state B (output 1)
        else
            out <= (out == 1'b1) ? (in ? 1'b1 : 1'b0) // B --0--> A(0), B --1--> B(1)
                                   : (in ? 1'b0 : 1'b1); // A --0--> B(1), A --1--> A(0)
    end

endmodule