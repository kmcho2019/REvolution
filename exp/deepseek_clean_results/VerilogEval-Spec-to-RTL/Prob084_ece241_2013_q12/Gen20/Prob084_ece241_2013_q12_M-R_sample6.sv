module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    wire [7:0] Q;
    wire [2:0] sel = {A, B, C};
    
    // 8-bit shift register using explicit DFF assignments
    reg q0, q1, q2, q3, q4, q5, q6, q7;
    
    always @(posedge clk) begin
        if (enable) begin
            q0 <= S;
            q1 <= q0;
            q2 <= q1;
            q3 <= q2;
            q4 <= q3;
            q5 <= q4;
            q6 <= q5;
            q7 <= q6;
        end
    end
    
    assign Q = {q7, q6, q5, q4, q3, q2, q1, q0};
    
    // Inline 8:1 multiplexer
    assign Z = Q[sel];
endmodule