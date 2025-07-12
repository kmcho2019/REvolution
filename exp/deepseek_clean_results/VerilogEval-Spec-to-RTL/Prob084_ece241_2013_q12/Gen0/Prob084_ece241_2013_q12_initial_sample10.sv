module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // 8-bit shift register
    reg [7:0] Q;
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Shift left, MSB first
        end
    end

    // 8:1 multiplexer to select output based on ABC
    assign Z = (A == 0 && B == 0 && C == 0) ? Q[0] :
               (A == 0 && B == 0 && C == 1) ? Q[1] :
               (A == 0 && B == 1 && C == 0) ? Q[2] :
               (A == 0 && B == 1 && C == 1) ? Q[3] :
               (A == 1 && B == 0 && C == 0) ? Q[4] :
               (A == 1 && B == 0 && C == 1) ? Q[5] :
               (A == 1 && B == 1 && C == 0) ? Q[6] :
               Q[7];

endmodule