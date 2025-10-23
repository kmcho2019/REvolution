module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state; // States: 00 - both p and q are 0, 01 - p is 0, q is 1, 10 - p is 1, q is 0, 11 - both p and q are 1

always @(posedge clock) begin
    case (state)
        2'b00: if (a == 1'b1) state <= 2'b11; // Set p and q when a is high
        2'b01: if (a == 1'b1) state <= 2'b11; // Set p when a is high
        2'b10: if (a == 1'b1) state <= 2'b11; // Set q when a is high and p is set
        2'b11: if (a == 1'b0) state <= 2'b11; // Keep state when a is low
    endcase
end

always @(negedge clock) begin
    case (state)
        2'b00: if (a == 1'b1) state <= 2'b00; // Reset when a is high during low clock phase
        2'b01: if (a == 1'b1) state <= 2'b00; // Reset q when a is high during low clock phase
        2'b10: if (a == 1'b1) state <= 2'b00; // Reset p when a is high during low clock phase
        2'b11: if (a == 1'b1) state <= 2'b00; // Reset both when a is high during low clock phase
    endcase
end

always @(*) begin
    case (state)
        2'b00: begin p = 1'b0; q = 1'b0; end
        2'b01: begin p = 1'b0; q = 1'b1; end
        2'b10: begin p = 1'b1; q = 1'b0; end
        2'b11: begin p = 1'b1; q = 1'b1; end
    endcase
end

endmodule