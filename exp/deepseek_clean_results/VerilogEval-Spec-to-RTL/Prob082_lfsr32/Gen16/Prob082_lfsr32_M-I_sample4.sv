module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

// Stage 1: Calculate XOR taps
reg [31:0] q_next;
wire tap_22 = q[22] ^ q[0];
wire tap_2 = q[2] ^ q[0];
wire tap_1 = q[1] ^ q[0];

// Stage 2: Register update
always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
        q_next <= 32'h1;
    end else begin
        q_next <= {q[0], q[31:23], tap_22, q[21:3], tap_2, tap_1};
        q <= q_next;
    end
end

endmodule