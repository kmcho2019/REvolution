module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] state;
assign out = state[0];

always @(posedge clk) begin
    if (~resetn) begin
        state <= 4'b0000;
    end else begin
        state <= {in, state[3:1]};
    end
end

endmodule