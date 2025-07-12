module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] input_reg;
reg [63:0] shift_reg;
reg [63:0] output_reg;

// Input register
always @(posedge clk) begin
    if (load) begin
        input_reg <= data;
    end else begin
        input_reg <= input_reg;
    end
end

// Shift stage
always @(posedge clk) begin
    if (ena) begin
        case (amount)
            2'b00: shift_reg <= {input_reg[62:0], 1'b0}; // Shift left by 1 bit
            2'b01: shift_reg <= {input_reg[55:0], 8'd0}; // Shift left by 8 bits
            2'b10: shift_reg <= {input_reg[63], input_reg[63:1]}; // Shift right by 1 bit (arithmetic)
            2'b11: shift_reg <= {{8{input_reg[63]}}, input_reg[63:8]}; // Shift right by 8 bits (arithmetic)
            default: shift_reg <= input_reg;
        endcase
    end else begin
        shift_reg <= shift_reg;
    end
end

// Output register
always @(posedge clk) begin
    output_reg <= shift_reg;
end

// Output assignment
assign q = output_reg;

endmodule