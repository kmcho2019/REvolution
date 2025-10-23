module TopModule(
    input clk,
    input a,
    output reg q
);
    
// Specify technology-specific attributes for optimization
(* synthesis_attribute = "dont_touch" *) // Prevents synthesis from modifying the q register
(* synthesis_attribute = "async_reset" *) // Specifies asynchronous reset style, if applicable

initial q = 1'b1;
always @(posedge clk) 
    q <= ~a;

endmodule