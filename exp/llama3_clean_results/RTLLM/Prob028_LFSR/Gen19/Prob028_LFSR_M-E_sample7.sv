// Bit Shifting Module
module bit_shifter (
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    input  [3:0]    in,        // Input to be shifted
    input           feedback,  // Feedback value to be inserted
    output reg [3:0] out  // Output after shifting and feedback insertion
);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0;
        end else begin
            out <= {in[2:0], feedback};
        end
    end

endmodule

// Feedback Calculation Module
module feedback_calculator (
    input  [3:0]    in,        // Input for feedback calculation
    output reg      feedback  // Calculated feedback value
);

    always @(*) begin
        feedback = in[3] ^ in[2];
    end

endmodule

// Top-level LFSR Module
module LFSR (
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out  // Output representing the current state of the LFSR
);

    wire [3:0] shifted_out;
    wire feedback;

    // Instantiate the bit shifting module
    bit_shifter bit_shifter_inst (
       .clk(clk),
       .rst(rst),
       .in(out),
       .feedback(feedback),
       .out(shifted_out)
    );

    // Instantiate the feedback calculation module
    feedback_calculator feedback_calculator_inst (
       .in(out),
       .feedback(feedback)
    );

    // Assign the shifted output back to out
    always @(posedge clk) begin
        if (!rst) begin
            out <= shifted_out;
        end
    end

endmodule

// Testbench for the LFSR
module LFSR_testbench;
    reg clk = 0;
    reg rst = 1;
    wire [3:0] out;

    // Instantiate the LFSR module
    LFSR lfsr_inst (
       .clk(clk),
       .rst(rst),
       .out(out)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Reset assertion
    initial #10 rst = 0;

    // Monitor output
    initial begin
        $display("Time = %0d, out = %b", $time, out);
        forever #10 $display("Time = %0d, out = %b", $time, out);
    end

    // Verification
    initial begin
        #100;
        $display("Verification: Expected sequence length is 15 for a 4-bit LFSR.");
        $finish;
    end

endmodule