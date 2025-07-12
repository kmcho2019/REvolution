module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Combinational next state logic
wire [31:0] next_q;
assign next_q = {
    q[0],                     // New MSB (position 32)
    q[31:23],                 // Untapped positions 31-23
    q[22] ^ q[0],             // Tapped position 22
    q[21:3],                  // Untapped positions 21-3
    q[2] ^ q[0],              // Tapped position 2
    q[1] ^ q[0]               // Tapped position 1
};

// Sequential logic with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= next_q;
    end
end

endmodule