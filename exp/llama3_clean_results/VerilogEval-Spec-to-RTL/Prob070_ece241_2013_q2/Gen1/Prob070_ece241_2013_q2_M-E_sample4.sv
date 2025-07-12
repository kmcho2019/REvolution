module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Using a case statement to implement the truth table directly
always @(a, b, c, d) begin
    case ({a, b, c, d})
        4'b0010, 4'b0111, 4'b1111: begin
            out_sop = 1'b1;
            // For POS, since we directly consider the conditions where output is 1,
            // we can use a similar approach but need to ensure the logic is correct
            // for the product of sums form.
            out_pos = 1'b1;
        end
        default: begin
            out_sop = 1'b0;
            // For out_pos, any condition not leading to a 1 in the SOP should
            // not lead to a 1 in the POS either, considering the direct implementation.
            out_pos = 1'b0;
        end
    endcase
end

endmodule