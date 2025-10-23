module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

integer i;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (i = 0; i < 512; i++) begin
            if (i == 0) begin
                // left neighbor is always 0 for the first cell
                q_reg[i] <= (q_reg[0] ^ q_reg[1]);
            end else if (i == 511) begin
                // right neighbor is always 0 for the last cell
                q_reg[i] <= (q_reg[510] ^ q_reg[511]);
            end else begin
                q_reg[i] <= (q_reg[i-1] ^ q_reg[i+1]);
            end
        end
    end
end

assign q = q_reg;

endmodule