module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

wire feedback;
reg [3:0] next_state;

// Parallel feedback calculation
assign feedback = ~(out[3] ^ out[2]);

// Next state logic (combinational)
always @(*) begin
    if (rst) begin
        next_state = 4'b0001;
    end else begin
        next_state = {out[2:0], feedback};
    end
end

// Dual-edge triggered state update
always @(posedge clk, negedge clk) begin
    out <= next_state;
end

endmodule