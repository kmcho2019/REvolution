module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    // Clock gating
    wire gated_clk;
    assign gated_clk = clk & enable;

    // Shift register implementation
    reg [7:0] shift_reg;
    always @(posedge gated_clk) begin
        shift_reg <= {shift_reg[6:0], S};
    end

    // Optimized 8:1 mux implementation
    reg mux_out;
    always @(*) begin
        case ({A, B, C})
            3'b000: mux_out = shift_reg[0];
            3'b001: mux_out = shift_reg[1];
            3'b010: mux_out = shift_reg[2];
            3'b011: mux_out = shift_reg[3];
            3'b100: mux_out = shift_reg[4];
            3'b101: mux_out = shift_reg[5];
            3'b110: mux_out = shift_reg[6];
            3'b111: mux_out = shift_reg[7];
            default: mux_out = 1'b0;
        endcase
    end

    assign Z = mux_out;
endmodule