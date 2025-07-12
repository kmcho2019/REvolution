module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg = data;
    end else begin
        // Compute next state using XOR of left and right neighbors
        q_reg = ({1'b0, q_reg[511:1]}) ^ ({q_reg[510:0], 1'b0});
    end
end

assign q = q_reg;

endmodule