module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output reg Z
);

    reg Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;

    // Shift register logic with explicit flip-flops
    always @(posedge clk) begin
        if (enable) begin
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

    wire [2:0] select = {A, B, C};

    // Balanced mux tree using conditional (?:) operators
    wire z0 = Q0;
    wire z1 = Q1;
    wire z2 = Q2;
    wire z3 = Q3;
    wire z4 = Q4;
    wire z5 = Q5;
    wire z6 = Q6;
    wire z7 = Q7;

    wire z_low  = (select[1:0] == 2'b00) ? z0 :
                  (select[1:0] == 2'b01) ? z1 :
                  (select[1:0] == 2'b10) ? z2 : z3;

    wire z_high = (select[1:0] == 2'b00) ? z4 :
                  (select[1:0] == 2'b01) ? z5 :
                  (select[1:0] == 2'b10) ? z6 : z7;

    always @(*) begin
        if (select[2] == 1'b0)
            Z = z_low;
        else
            Z = z_high;
    end

endmodule