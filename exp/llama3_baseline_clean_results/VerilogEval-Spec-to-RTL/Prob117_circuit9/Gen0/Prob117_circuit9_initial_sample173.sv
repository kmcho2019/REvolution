module TopModule(
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] q_reg;

always @ (posedge clk) begin
    if (a) begin
        q_reg <= 4; // hold the counter at 4 when a is high
    end else begin
        if (q_reg == 7) begin
            q_reg <= 0; // reset to 0 when counter reaches 7
        end else if (q_reg == 0) begin
            q_reg <= 1; // start from 1 after reset
        end else begin
            q_reg <= q_reg + 1; // increment counter
        end
    end
end

assign q = q_reg;

initial begin
    q_reg = 4; // initialize q_reg to 4
end

endmodule