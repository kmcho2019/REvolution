module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    // Determine the next state of Q based on the current state and inputs
    // If both j and k are 0, Q remains the same
    // If j is 0 and k is 1, Q becomes 0
    // If j is 1 and k is 0, Q becomes 1
    // If both j and k are 1, Q becomes the inverse of its current state
    Q <= (j == 1'b0 && k == 1'b0)? Q :
         (j == 1'b0 && k == 1'b1)? 1'b0 :
         (j == 1'b1 && k == 1'b0)? 1'b1 :
         (j == 1'b1 && k == 1'b1)? ~Q : Q;
end

endmodule