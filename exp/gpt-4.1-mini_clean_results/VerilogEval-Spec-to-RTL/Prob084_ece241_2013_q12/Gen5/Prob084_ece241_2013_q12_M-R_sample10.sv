module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

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

    wire [7:0] Q_bus = {Q7, Q6, Q5, Q4, Q3, Q2, Q1, Q0};
    wire [2:0] sel = {A, B, C};

    reg z_reg;
    always @(*) begin
        case (sel)
            3'b000: z_reg = Q0;
            3'b001: z_reg = Q1;
            3'b010: z_reg = Q2;
            3'b011: z_reg = Q3;
            3'b100: z_reg = Q4;
            3'b101: z_reg = Q5;
            3'b110: z_reg = Q6;
            3'b111: z_reg = Q7;
            default: z_reg = 1'b0; // default case to avoid latches
        endcase
    end

    assign Z = z_reg;

endmodule