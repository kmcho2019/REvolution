module TopModule(
    input  clk,
    input  resetn,
    input  in,
    output out
);

// Define the width of the shift register
parameter WIDTH = 4;

// Declare the registers
reg [WIDTH-1:0] shift_reg;

// Assign the output to the last bit of the shift register
assign out = shift_reg[WIDTH-1];

// Always block to handle the sequential logic
always @(posedge clk) begin
    if (~resetn) begin
        // Synchronous reset, clear the shift register
        shift_reg <= '0;
    end else begin
        // Shift the data to the right and input the new data from the left
        shift_reg <= {in, shift_reg[WIDTH-1:1]};
    end
end

endmodule