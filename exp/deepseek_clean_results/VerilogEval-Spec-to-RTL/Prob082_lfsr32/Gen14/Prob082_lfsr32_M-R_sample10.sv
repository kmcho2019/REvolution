module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire [31:0] next_q;

assign next_q = {q[0],                     // MSB is previous LSB
                q[31:23],                 // Untapped bits (31-23)
                q[22] ^ q[0],            // Tap at 22
                q[21:3],                 // Untapped bits (21-3)
                q[2] ^ q[0],             // Tap at 2
                q[1] ^ q[0]};            // Tap at 1

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= next_q;
    end
end

endmodule