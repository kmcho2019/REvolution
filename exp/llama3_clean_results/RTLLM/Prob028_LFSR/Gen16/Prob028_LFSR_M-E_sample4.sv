// Parameterizable Galois LFSR module
module Galois_LFSR #
(
    parameter SIZE = 4,  // Size of the LFSR
    parameter POLY_COEFFS = 4'b1100  // Polynomial coefficients (e.g., x^4 + x^3 + 1)
)
(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [SIZE-1:0] out  // Output representing the current state of the LFSR
);

// Internal signal for the current state
reg [SIZE-1:0] state;

// Always block for sequential logic
always @(posedge clk) begin
    if (rst) begin // Reset condition: initialize state to zero
        state <= {SIZE{1'b0}};
    end else begin // Normal operation: update LFSR state
        reg [SIZE-1:0] next_state;
        
        // Calculate the new bit based on the polynomial coefficients
        reg new_bit;
        new_bit = 1'b0;
        for (int i = 0; i < SIZE; i++) begin
            if (POLY_COEFFS[i]) begin
                new_bit ^= state[i];
            end
        end
        
        // Shift the bits in the LFSR and insert the new bit
        next_state[SIZE-1] = new_bit;
        for (int i = 0; i < SIZE-1; i++) begin
            next_state[i] = state[i+1];
        end
        
        state <= next_state;
    end
end

// Continuous assignment to output
assign out = state;

endmodule

// Example testbench for Galois LFSR
module Galois_LFSR_testbench;
    reg clk;
    reg rst;
    wire [3:0] out;

    // Instantiate the Galois LFSR module
    Galois_LFSR #(.SIZE(4),.POLY_COEFFS(4'b1100)) lfsr_inst (
      .clk(clk),
      .rst(rst),
      .out(out)
    );

    // Initial conditions
    initial begin
        clk = 0;
        rst = 1;
        #10 rst = 0;
    end

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Monitor output
    initial begin
        $monitor("Time = %0d, out = %b", $time, out);
    end

endmodule