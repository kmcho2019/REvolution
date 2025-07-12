module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output reg [7:0] q
);
    always @(posedge clk) begin
        if (reset)
            q <= 8'b0;  // synchronous active-high reset to zero
        else
            q <= d;
    end
endmodule