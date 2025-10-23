module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Use a case statement to evaluate the input combinations for SOP
always @(*) begin
    case ({a, b, c, d})
        4'b0111,  // 7
        4'b1111:  // 15
            out_sop = 1'b1;
        4'b0010:  // 2
            out_sop = 1'b1;
        default:
            out_sop = 1'b0;
    endcase
end

// Use bitwise OR to derive the POS expression
assign out_pos = ~(~a & ~b & ~c & ~d) & ~(a & ~b & c & ~d) & ~(a & ~b & ~c & d) & 
                 ~(~a & b & c & ~d) & ~(~a & b & ~c & d) & ~(~a & ~b & c & d) & 
                 ~(a & b & ~c & ~d) & ~(~a & b & ~c & ~d) & ~(~a & ~b & ~c & ~d);

endmodule