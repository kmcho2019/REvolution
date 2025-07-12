module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

    // Individual D flip-flops for the shift register
    reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;
    
    always @(posedge clk) begin
        if (enable) begin
            Q7 <= Q6;
            Q6 <= Q5;
            Q5 <= Q4;
            Q4 <= Q3;
            Q3 <= Q2;
            Q2 <= Q1;
            Q1 <= Q0;
            Q0 <= S;  // MSB shifted in first
        end
    end

    // 8:1 multiplexer using case statement
    always @(*) begin
        case ({A, B, C})
            3'b000: Z = Q0;
            3'b001: Z = Q1;
            3'b010: Z = Q2;
            3'b011: Z = Q3;
            3'b100: Z = Q4;
            3'b101: Z = Q5;
            3'b110: Z = Q6;
            3'b111: Z = Q7;
        endcase
    end

endmodule