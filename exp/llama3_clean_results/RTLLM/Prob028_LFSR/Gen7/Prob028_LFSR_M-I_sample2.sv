// Improved LFSR module with internal state register
module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output [3:0] out // 4-bit output representing the current state of the LFSR
);

// Internal register to hold the current state of the LFSR
reg [3:0] state;

// Calculate feedback based on the current state
wire feedback = ~(state[3] ^ state[2]);

// Calculate next state by shifting left and inserting feedback at LSB
wire [3:0] next_state = {state[2:0], feedback};

// Synchronous reset to initialize the state register
always @ (posedge clk) begin
    if (rst) begin // If reset is high, initialize the state to zero
        state <= 4'b0;
    end else begin // Otherwise, update the state with the next state
        state <= next_state;
    end
end

// Assign the current state to the output
assign out = state;

endmodule

// Improved testbench to verify the LFSR module
module tb_LFSR;
reg clk, rst;
wire [3:0] out;

LFSR uut (.clk(clk), .rst(rst), .out(out));

initial begin
    $dumpfile("LFSR.vcd"); // Dump the simulation to a VCD file for waveform viewing
    $dumpvars(0, tb_LFSR); // Dump all variables for debugging
    clk = 0;
    rst = 1;
    #10;
    rst = 0;
    forever #5 clk = ~clk;
end

initial begin
    #100;
    $display("LFSR Output at the end of simulation: %b", out); // Display the final output
    $finish;
end

endmodule