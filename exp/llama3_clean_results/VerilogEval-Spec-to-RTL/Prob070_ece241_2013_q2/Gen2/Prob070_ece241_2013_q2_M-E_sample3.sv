module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Determine the decimal value of the 4-bit input
wire [3:0] input_value;
assign input_value = {a, b, c, d};

// Use a case statement to determine the output based on the input conditions
always @(*)
begin
    case (input_value)
        4'b0010: out_sop = 1'b1; // 2
        4'b0111: out_sop = 1'b1; // 7
        4'b1111: out_sop = 1'b1; // 15
        default: out_sop = 1'b0;
    endcase

    case (input_value)
        4'b0000, 4'b0001, 4'b0100, 4'b0101, 4'b0110, 4'b1001, 4'b1010, 4'b1101, 4'b1110: out_pos = 1'b0;
        default: out_pos = 1'b1;
    endcase
end

endmodule