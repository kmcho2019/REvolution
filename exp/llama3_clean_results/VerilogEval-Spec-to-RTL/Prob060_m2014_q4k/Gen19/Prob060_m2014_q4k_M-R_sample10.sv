module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] state;

always @(posedge clk) begin
    if (!resetn) begin
        state <= 4'b0000;
    end else begin
        state <= {state[2:0], in};
    end
end

assign out = state[3];

endmodule