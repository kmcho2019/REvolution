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
    wire [2:0] sel = {A, B, C};

    // Shift register implemented with continuous assignments
    wire [7:0] next_shift_reg = enable ? {shift_reg[6:0], S} : shift_reg;

    always @(posedge clk) begin
        shift_reg <= next_shift_reg;
    end

    // Mux implemented directly in top module
    assign Z = shift_reg[sel];
endmodule