// Improved and parameterizable LFSR module
module LFSR #
(
    parameter SIZE = 4  // Size of the LFSR
)
(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [SIZE-1:0] out  // Output representing the current state of the LFSR
);

// Internal signal for feedback calculation
reg [SIZE-1:0] state;

// Always block for sequential logic
always @(posedge clk) begin
    if (rst) begin // Reset condition: initialize state to zero
        state <= {SIZE{1'b0}};
    end else begin // Normal operation: update LFSR state
        // Calculate feedback (XOR of most significant and second most significant bits)
        reg feedback;
        feedback = ~(state[SIZE-1] ^ state[SIZE-2]);
        
        // Shift the bits in the LFSR and insert the new feedback value
        state <= {state[SIZE-2:0], feedback};
    end
end

// Continuous assignment to output
assign out = state;

endmodule

// Example testbench for LFSR
module LFSR_testbench;
    reg clk;
    reg rst;
    wire [3:0] out;

    // Instantiate the LFSR module
    LFSR #(.SIZE(4)) lfsr_inst (
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