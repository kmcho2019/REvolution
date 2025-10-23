module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Declare wires to hold intermediate results
    wire [1:0] count;

    // Use a case statement to enumerate the possibilities for a small input size
    // This approach can be more straightforward for small input vectors
    always @(*) begin
        case (in)
            3'b000: count = 2'b00;
            3'b001, 3'b010, 3'b100: count = 2'b01;
            3'b011, 3'b101, 3'b110: count = 2'b10;
            3'b111: count = 2'b11;
            default: count = 2'b00; // Default case, though not needed for a 3-bit input
        endcase
    end

    // Assign the count to the output
    assign out = count;

endmodule