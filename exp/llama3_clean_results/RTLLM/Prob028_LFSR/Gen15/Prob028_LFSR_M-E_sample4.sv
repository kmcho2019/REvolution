// Shift Register Module
module shift_register #(
    parameter LENGTH = 4 // Length of the shift register
) (
    input clk, // Clock signal
    input rst, // Active high reset signal
    input [LENGTH-1:0] data_in, // Input data to shift in
    output [LENGTH-1:0] data_out // Output of the shifted data
);

reg [LENGTH-1:0] state; // Internal state of the shift register

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        state <= '0; // Initialize the shift register on reset
    end else begin
        state <= {data_in[LENGTH-2:0], data_in[LENGTH-1]}; // Shift the data
    end
end

assign data_out = state; // Output the current state

endmodule

// Feedback Generation Module
module feedback_generator #(
    parameter LENGTH = 4 // Length of the LFSR
) (
    input [LENGTH-1:0] state, // Current state of the LFSR
    output feedback // Feedback value
);

assign feedback = ~(state[LENGTH-1] ^ state[LENGTH-2]); // Calculate the feedback value

endmodule

// Linear Feedback Shift Register (LFSR) Module
module LFSR #(
    parameter LENGTH = 4, // Length of the LFSR
    parameter SEED = 4'b0001 // Seed value for initialization
) (
    input clk, // Clock signal
    input rst, // Active high reset signal
    output [LENGTH-1:0] out // Output representing the current state of the LFSR
);

reg [LENGTH-1:0] state; // Internal state of the LFSR
wire feedback; // Feedback value

shift_register #(.LENGTH(LENGTH)) shift_reg (
    .clk(clk),
    .rst(rst),
    .data_in({state[LENGTH-2:0], feedback}), // Shift in the new feedback value
    .data_out(state)
);

feedback_generator #(.LENGTH(LENGTH)) feedback_gen (
    .state(state),
    .feedback(feedback)
);

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        state <= SEED; // Initialize the LFSR with the specified seed value
    end
end

assign out = state; // Output the current state of the LFSR

endmodule

// Testbench for the LFSR
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