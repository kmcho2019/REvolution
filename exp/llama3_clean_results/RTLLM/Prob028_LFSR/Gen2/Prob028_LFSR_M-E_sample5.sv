module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

reg [3:0] next_state;
reg feedback;

always @(*) begin
    feedback = ~(out[3] ^ out[2]);
    next_state = {out[2:0], feedback};
end

always @ (posedge clk) begin
    if (rst) out <= 4'd1; // Initialize with a non-zero value for a longer sequence
    else out <= next_state;
end

endmodule