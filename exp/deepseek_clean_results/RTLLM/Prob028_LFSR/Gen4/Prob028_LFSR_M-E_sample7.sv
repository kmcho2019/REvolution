module LFSR (
    input clk,
    input rst_n,            // Active-low reset
    input load,             // Load new seed
    input [3:0] seed,       // Initial seed value
    input oe,               // Output enable
    output reg [3:0] out    // Current state
);

// Configurable polynomial (default matches original problem)
parameter POLY_MASK = 4'b1100;

// Internal next state calculation
wire [3:0] next_state;
wire feedback;

// Calculate feedback using reduction XOR on masked bits
assign feedback = ^(out & POLY_MASK);

// Next state is either shifted with feedback or loaded seed
assign next_state = load ? seed : {out[2:0], feedback};

// State update logic with synchronous reset
always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0001;     // Default reset state
    end
    else begin
        out <= next_state;
    end
end

// Output enable control
assign out = oe ? out : 4'bzzzz;

endmodule