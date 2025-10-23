module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    // Hybrid operation: shift takes priority if both enables are active
    q <= shift_ena ? {q[2:0], data} : 
         count_ena ? q - 1'b1 : 
         q;
    
    // Alternative implementation with explicit parallel computation:
    // q <= (shift_ena & {4{shift_ena}}) & {q[2:0], data} |
    //      (~shift_ena & {4{count_ena}}) & (q - 1'b1) |
    //      (~shift_ena & ~count_ena) & q;
end

endmodule