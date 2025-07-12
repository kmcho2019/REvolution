module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

wire [3:0] input_combination;

assign input_combination = {a, b, c, d};

// Direct implementation of SOP expression using a case statement
always @(*)
begin
    case (input_combination)
        4'b0010, 4'b0111, 4'b1111: out_sop = 1'b1;
        default: out_sop = 1'b0;
    endcase
end

// Derivation of POS expression using a case statement
always @(*)
begin
    case (input_combination)
        4'b0000, 4'b0001, 4'b0100, 4'b0101, 4'b0110, 4'b1001, 4'b1010, 4'b1101, 4'b1110: out_pos = 1'b0;
        default: out_pos = 1'b1;
    endcase
end

endmodule