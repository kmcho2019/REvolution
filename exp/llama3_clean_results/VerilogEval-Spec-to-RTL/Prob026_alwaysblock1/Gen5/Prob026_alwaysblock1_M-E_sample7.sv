module TopModule #(
    parameter MODE = 2'b00 // 00: assign, 01: always, 10: both, 11: invalid
)(
    input  a,
    input  b,
    output reg out_assign,
    output reg out_alwaysblock
);

// Using assign statement
assign out_assign = a & b;

// Combinational always block with LUT implementation
always @(*) begin
    case ({a, b})
        2'b00: out_alwaysblock = 1'b0;
        2'b01: out_alwaysblock = 1'b0;
        2'b10: out_alwaysblock = 1'b0;
        2'b11: out_alwaysblock = 1'b1;
        default: out_alwaysblock = 1'bx;
    endcase
end

// Mode selector to output either assign, always, or both
always @(*) begin
    case (MODE)
        2'b00: begin
            out_assign = a & b;
            out_alwaysblock = 1'bz;
        end
        2'b01: begin
            out_assign = 1'bz;
            out_alwaysblock = a & b;
        end
        2'b10: begin
            out_assign = a & b;
            out_alwaysblock = a & b;
        end
        default: begin
            out_assign = 1'bx;
            out_alwaysblock = 1'bx;
        end
    endcase
end

endmodule