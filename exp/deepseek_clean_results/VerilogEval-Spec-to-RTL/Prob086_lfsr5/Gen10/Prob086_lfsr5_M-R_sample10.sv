module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire [4:0] next_q;

assign next_q = {q[0],               // New MSB is current LSB
                q[4],                 // Bit 4 shifts right
                q[3] ^ q[0],          // Tapped bit (position 3)
                q[2],                 // Bit 2 shifts right
                q[1]};               // Bit 1 shifts right

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        q <= next_q;
    end
end

endmodule