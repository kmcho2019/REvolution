// Define a shift register module to handle n-bit data
module ShiftRegister #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

// Internal signal to store the shifted data
logic [WIDTH-1:0] shifted_data;

// Initialize the shifted data to zero
initial begin
    shifted_data = '0;
end

// Always block to handle the clock edge and reset
always_ff @(posedge clk) begin
    if (reset == 1'b1) begin
        // Clear the shift register when reset is high
        shifted_data <= '0;
    end else begin
        // Shift the input data into the shift register
        shifted_data <= {d[WIDTH-2:0], 1'b0};
    end
end

// Continuous assignment to output the shifted data
assign q = shifted_data;

endmodule

// Instantiate the ShiftRegister module within the TopModule
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Use the ShiftRegister module with the specified width
ShiftRegister #(.WIDTH(8)) shift_reg(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule