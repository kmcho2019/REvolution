module TopModule (
    input          clk,
    input          load,
    input          ena,
    input  [1:0]   amount,
    input  [63:0]  data,
    output reg [63:0] q
);

    wire [63:0] shifted;
    reg  [63:0] sign_extended_q;

    // Combinational sign extension of MSB for arithmetic right shifts
    always @(*) begin
        sign_extended_q = {64{q[63]}};
    end

    // Combinational next value calculation based on amount
    // amount:
    // 00: shift left by 1
    // 01: shift left by 8
    // 10: shift right by 1 (arithmetic)
    // 11: shift right by 8 (arithmetic)
    assign shifted = (amount == 2'b00) ? (q << 1) :
                     (amount == 2'b01) ? (q << 8) :
                     (amount == 2'b10) ? ({sign_extended_q[63:1], q[63]}) >> 1 | ({sign_extended_q[63:1], q[63]} & 64'hFFFFFFFFFFFFFFFF) : // arithmetic right shift by 1
                     (amount == 2'b11) ? ({sign_extended_q[63:8], q[63:8]}) >> 8 | ({sign_extended_q[63:8], q[63:8]} & 64'hFFFFFFFFFFFFFFFF) : q;

    // A more straightforward and synthesizable way to do arithmetic right shift:
    // We can use arithmetic shift operators (>>>) in SystemVerilog,
    // but since we're to provide Verilog compatible code and some tools
    // might not support >>> on vectors, do sign-extended shifts manually.

    // To ensure synthesizability and clarity, rewrite shifted calculation in an always_comb:

    reg [63:0] next_val;

    always @(*) begin
        case(amount)
            2'b00: next_val = q << 1;
            2'b01: next_val = q << 8;
            2'b10: next_val = ({ {63{q[63]}}, q }) >> 1;  // arithmetic right shift by 1 with sign extension
            2'b11: next_val = ({ {56{q[63]}}, q }) >> 8;  // arithmetic right shift by 8 with sign extension
            default: next_val = q;
        endcase
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= next_val;
        // else q retains its value
    end

endmodule