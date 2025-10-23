// Define a 2-bit LFSR module
module LFSR_2bit(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [1:0] out  // 2-bit output representing the current state of the LFSR
);

// Internal signal for the feedback
wire feedback;

// Calculate the feedback based on the XOR of the bits
assign feedback = ~(out[1] ^ out[0]);

// Handle the clock edge and reset conditions
always @ (posedge clk) begin
    if (rst) begin  // If reset is high, initialize all bits to zero
        out <= 2'b0;
    end else begin
        // Update the LFSR state by shifting left and inserting the feedback at the LSB
        out <= {out[0], feedback};
    end
end

endmodule

// Define the hierarchical 4-bit LFSR module
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Instantiate four 2-bit LFSRs
LFSR_2bit LFSR_0(
   .clk(clk),
   .rst(rst),
   .out(out[1:0])
);

LFSR_2bit LFSR_1(
   .clk(clk),
   .rst(rst),
   .out(out[3:2])
);

// Combine the outputs of LFSR_0 and LFSR_1
wire [1:0] LFSR_2_in;
assign LFSR_2_in = out[1:0] ^ out[3:2];

// Instantiate a 2-bit LFSR for LFSR_2
LFSR_2bit LFSR_2(
   .clk(clk),
   .rst(rst),
   .out(LFSR_2_in)
);

// Combine the outputs of LFSR_2 and LFSR_3
wire [1:0] LFSR_3_in;
assign LFSR_3_in = LFSR_2_in ^ out[3:2];

// Instantiate a 2-bit LFSR for LFSR_3
LFSR_2bit LFSR_3(
   .clk(clk),
   .rst(rst),
   .out(LFSR_3_in)
);

// Assign the final output
assign out = {LFSR_3_in, LFSR_2_in};

endmodule