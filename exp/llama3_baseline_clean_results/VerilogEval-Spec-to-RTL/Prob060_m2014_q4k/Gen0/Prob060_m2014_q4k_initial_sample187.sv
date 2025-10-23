module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] Q;

always @(posedge clk) begin
    if (!resetn) begin
        Q <= 4'b0000;
    end else begin
        Q <= {Q[2:0], in};
    end
end

assign out = Q[3];

endmodule