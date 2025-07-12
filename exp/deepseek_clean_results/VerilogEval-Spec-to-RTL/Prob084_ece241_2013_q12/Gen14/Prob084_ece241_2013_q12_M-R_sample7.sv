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

    // Shift register implementation using continuous assignment
    always @(posedge clk) begin
        shift_reg <= enable ? {shift_reg[6:0], S} : shift_reg;
    end

    // 8:1 mux implemented via direct indexing
    assign Z = shift_reg[sel];
endmodule