// Refactored LFSR module
module LFSR #(
    parameter LENGTH = 4, // Length of the shift register
    parameter SEED = 4'b0001 // Seed value for initialization
) (
    input clk, // Clock signal
    input rst, // Active high reset signal
    output [LENGTH-1:0] out // Output representing the current state of the LFSR
);

reg [LENGTH-1:0] state; // Internal state of the LFSR

// Calculate the feedback signal based on the tap positions
assign out = state;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Initialize the LFSR with the specified seed value
        state <= SEED;
    end else begin
        // Shift the state and insert the new feedback value
        state <= {state[LENGTH-2:0], ~(state[LENGTH-1] ^ state[LENGTH-2])};
    end
end

endmodule

// Refactored testbench for the LFSR
module tb_LFSR;
reg clk; // Clock signal
reg rst; // Active high reset signal
wire [3:0] out; // Output from the LFSR

LFSR #(.LENGTH(4), .SEED(4'b0001)) uut (.clk(clk), .rst(rst), .out(out));

initial begin
    clk = 1'b0;
    rst = 1'b1;
    #10;
    rst = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    $monitor("Time = %0d, out = %b", $time, out);
    #100;
    $finish;
end

endmodule