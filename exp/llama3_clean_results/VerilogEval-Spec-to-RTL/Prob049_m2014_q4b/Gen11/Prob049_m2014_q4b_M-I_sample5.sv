module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar)
    if (ar) 
        q <= 1'b0; // Asynchronous reset
    else if (clk) 
        q <= d;    // D flip-flop functionality on positive edge of clk

endmodule