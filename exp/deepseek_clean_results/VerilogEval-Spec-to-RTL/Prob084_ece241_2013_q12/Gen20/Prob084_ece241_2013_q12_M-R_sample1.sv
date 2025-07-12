module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    output [7:0] Q
);
    reg [7:0] Q_reg;

    // Explicit DFF assignments
    assign Q = Q_reg;
    
    always @(posedge clk) begin
        if (enable) begin
            Q_reg[0] <= S;
            Q_reg[1] <= Q_reg[0];
            Q_reg[2] <= Q_reg[1];
            Q_reg[3] <= Q_reg[2];
            Q_reg[4] <= Q_reg[3];
            Q_reg[5] <= Q_reg[4];
            Q_reg[6] <= Q_reg[5];
            Q_reg[7] <= Q_reg[6];
        end
    end
endmodule

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

    ShiftRegister8bit sr_inst (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    assign Z = Q[sel];
endmodule