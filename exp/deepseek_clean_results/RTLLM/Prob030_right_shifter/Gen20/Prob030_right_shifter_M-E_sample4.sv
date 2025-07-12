module right_shifter (
    input wire clk,
    input wire d,            // Serial input for shift mode
    input wire load,         // Control signal for parallel load
    input wire enable,       // Global enable
    input wire [7:0] data_in, // Parallel input for load mode
    output reg [7:0] q       // Output register
);

// Internal signals
wire [7:0] next_q;

// Clock gating logic
wire gated_clk;
assign gated_clk = clk & (enable & (load | |q)); // Only clock when active

// Next state logic
assign next_q = load ? data_in : {d, q[7:1]};

// Register update
always @(posedge gated_clk) begin
    q <= next_q;
end

endmodule