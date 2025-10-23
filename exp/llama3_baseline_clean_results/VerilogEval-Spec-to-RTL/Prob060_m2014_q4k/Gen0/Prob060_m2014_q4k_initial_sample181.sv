module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] reg_out;

always @(posedge clk) begin
    if (~resetn) begin
        reg_out <= 4'b0000;
    end else begin
        reg_out <= {reg_out[2:0], in};
    end
end

assign out = reg_out[3];

endmodule