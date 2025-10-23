module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    output [7:0] Q
);
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {shift_reg[6:0], S};
        end
    end

    assign Q = shift_reg;
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