module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

wire [1:0] sel;
assign sel = {a, b};

// Using a single 4-to-1 multiplexer for both sum and carry-out
// The inputs 'a' and 'b' are used as the select lines
// Predefined outputs for sum and carry-out based on 'a' and 'b'
always @(*)
begin
    case (sel)
        2'b00: begin sum = 0; cout = 0; end
        2'b01: begin sum = 1; cout = 0; end
        2'b10: begin sum = 1; cout = 0; end
        2'b11: begin sum = 0; cout = 1; end
    endcase
end

endmodule