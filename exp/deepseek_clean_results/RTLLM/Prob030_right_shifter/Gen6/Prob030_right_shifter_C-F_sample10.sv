module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,    // Clock gating control
    input wire reset_n,   // Active-low synchronous reset
    output reg [7:0] q
);

// Internal wire for the shifted value
wire [7:0] next_q;

// Clock gating for power optimization
wire gated_clk;
assign gated_clk = clk & enable;

// Combinational logic for the shift operation
assign next_q = {d, q[7:1]};

// Sequential update of the register with synchronous reset
always @(posedge gated_clk) begin
    if (!reset_n) begin
        q <= 8'b0;        // Synchronous reset
    end else begin
        q <= next_q;      // Normal operation
    end
end

endmodule