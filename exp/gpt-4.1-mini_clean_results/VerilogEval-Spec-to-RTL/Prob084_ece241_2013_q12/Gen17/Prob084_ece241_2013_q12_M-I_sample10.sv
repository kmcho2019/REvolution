module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // Shift register bits as individual flip-flops
    reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;

    // Registered select inputs to reduce glitches on mux inputs
    reg [2:0] sel_reg;

    always @(posedge clk) begin
        // Register select inputs
        sel_reg <= {A, B, C};

        if (enable) begin
            // Shift left, shift in S at Q0 (LSB)
            Q7 <= Q6;
            Q6 <= Q5;
            Q5 <= Q4;
            Q4 <= Q3;
            Q3 <= Q2;
            Q2 <= Q1;
            Q1 <= Q0;
            Q0 <= S;
        end
    end

    // 8-to-1 mux using case statement, input bits labeled Q[0]=Q0, ..., Q[7]=Q7
    reg Z_reg;
    always @(*) begin
        case (sel_reg)
            3'b000: Z_reg = Q0;
            3'b001: Z_reg = Q1;
            3'b010: Z_reg = Q2;
            3'b011: Z_reg = Q3;
            3'b100: Z_reg = Q4;
            3'b101: Z_reg = Q5;
            3'b110: Z_reg = Q6;
            3'b111: Z_reg = Q7;
            default: Z_reg = 1'b0;
        endcase
    end

    assign Z = Z_reg;

endmodule