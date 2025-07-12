module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Synchronous reset assumed for defined initialization
// If no reset is available, we can initialize q on first clock edge or leave it uninitialized per problem statement.
// Here, we add an initial block to initialize for simulation purposes.
// In actual FPGA/ASIC design, a reset signal is recommended.

// Compute next state combinationally
wire [2:0] next_q;
wire invalid_state = (q > 3'd6);  // invalid if q > 6

assign next_q = a ? 3'd4 : 
                (invalid_state ? 3'd4 :  // recover invalid states
                 (q == 3'd6) ? 3'd0 :    // wrap around modulo 7
                 (q + 3'd1));

always @(posedge clk) begin
    q <= next_q;
end

// Optional initial block for simulation
initial q = 3'd4;

endmodule