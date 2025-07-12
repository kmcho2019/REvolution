// Shift Register Module with Novel Architecture
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg [3:0] out
);

reg [3:0] state;

always @(posedge clk) begin
    if (!resetn) begin
        state <= 4'b0000;
    end else begin
        state <= {in, state[3:1]};
    end
end

assign out = state;

endmodule