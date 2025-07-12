module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

reg [15:0] q_reg;

always @(posedge clk) begin
    if (~resetn) begin
        q_reg <= 16'd0; // synchronous reset
    end else begin
        if (byteena[1]) begin
            q_reg[15:8] <= d[15:8]; // update upper byte
        end
        if (byteena[0]) begin
            q_reg[7:0] <= d[7:0]; // update lower byte
        end
    end
end

assign q = q_reg;

endmodule