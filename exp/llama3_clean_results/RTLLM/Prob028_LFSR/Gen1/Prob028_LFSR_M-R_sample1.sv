module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

reg [3:0] state;

// Calculate the feedback value
wire feedback = ~(out[3] ^ out[2]);

// Sequential logic to update the state
always @(posedge clk) begin
    if (rst) begin
        state <= 4'b0000;
    end else begin
        state <= {out[2:0], feedback};
    end
end

// Continuous assignment for output
assign out = state;

endmodule