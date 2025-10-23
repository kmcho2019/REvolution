module TopModule (
    input        clk,
    input  [7:0] d,
    output reg [7:0] q
);
    // Single always block for 8-bit register capturing input on posedge clk
    always @(posedge clk) begin
        q <= d;
    end
endmodule