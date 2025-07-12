module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] Q;

// Define the shift register's behavior using a for loop
always @(posedge clk) begin
    if (enable) begin
        for (int i = 7; i > 0; i--) begin
            Q[i] <= Q[i-1];
        end
        Q[0] <= S;
    end
end

// Use a conditional assignment for the multiplexer
assign Z = (A == 0 && B == 0 && C == 0) ? Q[0] :
           (A == 0 && B == 0 && C == 1) ? Q[1] :
           (A == 0 && B == 1 && C == 0) ? Q[2] :
           (A == 0 && B == 1 && C == 1) ? Q[3] :
           (A == 1 && B == 0 && C == 0) ? Q[4] :
           (A == 1 && B == 0 && C == 1) ? Q[5] :
           (A == 1 && B == 1 && C == 0) ? Q[6] :
           (A == 1 && B == 1 && C == 1) ? Q[7] : 1'bx;

endmodule