module right_shifter (
    input  wire       clk,
    input  wire       d,
    output reg  [7:0] q
);

// Initial value for simulation purposes only
initial q = 8'b0;

// Compute next state combinationally for clarity and synthesis friendliness
wire [7:0] next_q = {d, q[7:1]};

always @(posedge clk) begin
    q <= next_q;
end

endmodule