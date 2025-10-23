// Define a parameterizable shift register module
module shift_register(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    input [63:0] data_in,  // Input data
    output reg [63:0] data_out  // Output data
);

// Always block for sequential logic
always @(posedge clk or negedge rst_n) begin
    // Reset condition: Set data_out to 0 when rst_n is low
    if (~rst_n) begin
        data_out <= 64'd0;
    end else begin
        data_out <= data_in;
    end
end

endmodule

// Define the module for the 64-bit Johnson counter
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Internal wires for the next state computation
wire [63:0] Q_next;

// Instance of the shift register for the current state (Q)
shift_register u_Q(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(Q_next),
    .data_out(Q)
);

// Combinational logic for the next state computation
always @(*) begin
    // Update Q_next based on the current state (Q)
    // If Q[0] is 1, shift right and append 0; otherwise, shift right and append 1
    Q_next = Q[0] ? {1'b0, Q[63:1]} : {1'b1, Q[63:1]};
end

endmodule