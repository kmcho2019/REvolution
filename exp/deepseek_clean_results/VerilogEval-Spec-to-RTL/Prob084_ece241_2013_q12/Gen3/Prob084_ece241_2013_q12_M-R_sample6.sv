module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // Individual flip-flop declarations for the shift register
    reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;
    
    // Shift register implementation using individual flip-flops
    always @(posedge clk) begin
        if (enable) begin
            Q0 <= S;
            Q1 <= Q0;
            Q2 <= Q1;
            Q3 <= Q2;
            Q4 <= Q3;
            Q5 <= Q4;
            Q6 <= Q5;
            Q7 <= Q6;
        end
    end

    // 8:1 multiplexer using case statement
    reg Z_temp;
    always @(*) begin
        case ({A, B, C})
            3'b000: Z_temp = Q0;
            3'b001: Z_temp = Q1;
            3'b010: Z_temp = Q2;
            3'b011: Z_temp = Q3;
            3'b100: Z_temp = Q4;
            3'b101: Z_temp = Q5;
            3'b110: Z_temp = Q6;
            3'b111: Z_temp = Q7;
        endcase
    end

    assign Z = Z_temp;

endmodule