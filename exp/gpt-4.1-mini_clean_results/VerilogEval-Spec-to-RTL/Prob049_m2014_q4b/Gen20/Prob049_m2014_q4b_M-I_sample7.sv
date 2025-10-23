module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

    always @(posedge clk or posedge ar) begin
        if (ar)
            q = 1'b0;      // Blocking assignment for async reset, minimal logic
        else
            q <= d;        // Non-blocking for data latch on clk
    end

endmodule