module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire [4:0] tap_mask = 5'b10100; // Positions 5 and 3 (1-based)
wire [4:0] feedback = {5{q[0]}};
wire [4:0] next_state = (q >> 1) ^ (feedback & tap_mask);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        q <= next_state;
    end
end

endmodule