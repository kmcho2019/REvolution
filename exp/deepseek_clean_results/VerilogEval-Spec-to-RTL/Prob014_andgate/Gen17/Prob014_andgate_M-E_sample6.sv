`default_nettype none

module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);

    // Create 2-bit select signal from inputs
    wire [1:0] sel = {a, b};

    // Implement AND truth table using multiplexer
    // Truth table:
    // 00 -> 0
    // 01 -> 0
    // 10 -> 0
    // 11 -> 1
    assign out = (sel == 2'b11) ? 1'b1 : 1'b0;

    /* Alternative implementation showing the full mux structure:
    reg out_reg;
    always @(*) begin
        case(sel)
            2'b00: out_reg = 1'b0;
            2'b01: out_reg = 1'b0;
            2'b10: out_reg = 1'b0;
            2'b11: out_reg = 1'b1;
            default: out_reg = 1'b0;
        endcase
    end
    assign out = out_reg;
    */
endmodule