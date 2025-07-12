module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

// Internal wire for the shifted value
wire [7:0] next_q;

// Combinational logic for the shift operation
assign next_q = {d, q[7:1]};

// Initialize shift register to all zeros
initial begin
    q = 8'b0;
end

// Sequential update of the register
always @(posedge clk) begin
    q <= next_q;
end

endmodule