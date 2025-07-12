module TopModule(
    input  clk,
    input  a,
    output [2:0] q
);

reg [2:0] q_reg;
initial q_reg = 3'd4; // initialize q_reg to 4

always @(posedge clk) begin
    if (!a) begin
        if (q_reg == 3'd7) begin // if counter reaches 7, reset to 0
            q_reg <= 3'd0;
        end else if (q_reg == 3'd4 && a == 1'd1) begin
            q_reg <= 3'd4; // if 'a' is high and counter is 4, stay at 4
        end else begin
            q_reg <= q_reg + 1; // increment counter
        end
    end else begin
        q_reg <= 3'd4; // if 'a' is high, stay at 4
    end
end

assign q = q_reg;

endmodule