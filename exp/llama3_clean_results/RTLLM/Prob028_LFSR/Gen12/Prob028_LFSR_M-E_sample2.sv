// Parameterized LFSR module
module LFSR #(
    parameter LENGTH = 4, // Length of the shift register
    parameter TAPS = 2'b11 // Tap positions for feedback (most significant bits)
) (
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [LENGTH-1:0] out // Output representing the current state of the LFSR
);

reg [LENGTH-1:0] state; // Internal state of the LFSR

// Calculate the feedback signal based on the tap positions
wire feedback;
assign feedback = ~(state[LENGTH-1] ^ state[LENGTH-2]);

always @ (posedge clk) begin
    if (rst) begin
        // Initialize the LFSR with a seed value (e.g., all ones for simplicity)
        state <= {LENGTH{1'b1}};
    end else begin
        // Shift the state and insert the new feedback value
        state <= {state[LENGTH-2:0], feedback};
    end
end

assign out = state; // Output the current state

endmodule

// Testbench for the parameterized LFSR
module tb_LFSR;
reg clk; // Clock signal
reg rst; // Active high reset signal
wire [3:0] out; // Output from the LFSR

LFSR #(.LENGTH(4), .TAPS(2'b11)) uut (.clk(clk), .rst(rst), .out(out));

initial begin
    clk = 0;
    rst = 1;
    #10;
    rst = 0;
    forever #5 clk = ~clk;
end

initial begin
    $monitor("out = %b", out);
    #100;
    $finish;
end

endmodule