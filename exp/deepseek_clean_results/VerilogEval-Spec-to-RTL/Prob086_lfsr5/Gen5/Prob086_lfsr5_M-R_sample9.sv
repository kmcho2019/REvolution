module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire [4:0] next_q;

assign next_q[4] = q[0];                   // MSB gets the feedback
assign next_q[3] = q[4];                   // Simple shift
assign next_q[2] = q[3] ^ q[0];            // Tap at position 3 (q[2])
assign next_q[1] = q[2];                   // Simple shift
assign next_q[0] = q[1];                   // Simple shift

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        q <= next_q;
    end
end

endmodule