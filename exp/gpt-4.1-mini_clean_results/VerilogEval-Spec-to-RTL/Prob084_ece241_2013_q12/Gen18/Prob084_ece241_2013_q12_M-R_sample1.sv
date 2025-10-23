module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // Individual flip-flops representing Q[0] (MSB) ... Q[7] (LSB)
    reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;

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

    // Multiplexer select input formed from {A,B,C}
    wire [2:0] select = {A, B, C};

    // Output mux to select one Q bit based on ABC
    // Indexing Q[0] at select=0 to Q[7] at select=7 directly
    reg Z_reg;
    always @(*) begin
        case (select)
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