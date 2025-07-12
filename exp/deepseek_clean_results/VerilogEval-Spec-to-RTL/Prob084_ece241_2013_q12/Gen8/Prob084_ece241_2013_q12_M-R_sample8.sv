module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] shift_reg;
    wire [7:0] next_shift_reg = enable ? {shift_reg[6:0], S} : shift_reg;
    wire [2:0] sel = {A, B, C};

    always @(posedge clk) begin
        shift_reg <= next_shift_reg;
    end

    assign Z = shift_reg[sel];
endmodule