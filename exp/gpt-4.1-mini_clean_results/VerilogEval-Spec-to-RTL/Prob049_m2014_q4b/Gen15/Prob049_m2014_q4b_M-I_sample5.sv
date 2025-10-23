module TopModule (
    input  clk,
    input  ar,    // Asynchronous active-high reset
    input  d,
    output reg q
);

// Single always block with asynchronous reset
always @(posedge clk or posedge ar) begin
    if (ar)
        q <= 1'b0;      // Asynchronous reset
    else
        q <= d;         // Capture data on rising clock edge
end

endmodule