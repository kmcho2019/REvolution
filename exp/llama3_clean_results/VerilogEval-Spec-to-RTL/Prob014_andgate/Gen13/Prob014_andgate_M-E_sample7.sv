module TopModule(
    input  a,
    input  b,
    output out
);

// Define the lookup table for the AND operation
// Since this is a 2-input AND gate, we only need 4 entries
wire [1:0] input_combination;
assign input_combination = {a, b};

// The lookup table for AND operation
// 00 -> 0, 01 -> 0, 10 -> 0, 11 -> 1
always @(input_combination) begin
    case (input_combination)
        2'b00: out = 1'b0;
        2'b01: out = 1'b0;
        2'b10: out = 1'b0;
        2'b11: out = 1'b1;
        default: out = 1'b0; // Default case, though not necessary here
    endcase
end

endmodule