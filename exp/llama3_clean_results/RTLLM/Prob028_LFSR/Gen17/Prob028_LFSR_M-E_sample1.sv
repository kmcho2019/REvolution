// Modular LFSR implementation
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Internal signals
reg [3:0] shift_reg;  // Internal shift register
reg       feedback;   // Feedback signal

// Instantiate shift register module
shift_register shift_reg_module(
    .clk(clk),
    .rst(rst),
    .in(feedback),
    .out(shift_reg)
);

// Instantiate feedback generator module
feedback_generator feedback_gen_module(
    .in(shift_reg),
    .out(feedback)
);

// Update output
always @(*) begin
    out = shift_reg;
end

endmodule

// Shift register module
module shift_register(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    input           in,   // Input to shift register
    output reg [3:0] out  // Output of shift register
);

// Update shift register on the rising edge of the clock
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0;  // Reset to zero
    end else begin
        out <= {out[2:0], in};  // Shift left and insert input at LSB
    end
end

endmodule

// Feedback generator module
module feedback_generator(
    input  [3:0] in,  // Input to feedback generator
    output       out  // Output of feedback generator
);

// Calculate feedback as XOR of MSB and second MSB, then inverted
assign out = ~(in[3] ^ in[2]);

endmodule