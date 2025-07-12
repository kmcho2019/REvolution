// Define a shift register module to handle the reset value loading
module ShiftRegister(
    input clk,
    input reset,
    output [7:0] q
);

parameter RESET_VALUE = 8'h34; // Reset value

reg [7:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        // Load the reset value into the shift register
        q_reg <= {q_reg[6:0], RESET_VALUE[7]};
        // Shift the bits to the left to prepare for the next clock cycle
        q_reg <= q_reg << 1;
    end else begin
        // Normally, the shift register would shift the bits to the left
        // But in this implementation, it's not necessary as we're using the shift register
        // only for resetting the flip-flops
    end
end

assign q = q_reg;

endmodule

// Define the D flip-flop module with active high synchronous reset
module DFF(
    input clk,
    input reset,
    input d,
    output q
);

reg q_reg;

always @(negedge clk) begin
    if (reset) begin
        // In this implementation, we're relying on the ShiftRegister module
        // to load the reset value into the flip-flops
        // So, when reset is high, we don't need to do anything here
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule

// TopModule instantiates the 8-bit DFF using the ShiftRegister for reset
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate the ShiftRegister for loading the reset value
ShiftRegister u_shift_register(
    .clk(clk),
    .reset(reset),
    .q(q)
);

// Instantiate the 8-bit D flip-flop
DFF u_dff[7:0](
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);

endmodule