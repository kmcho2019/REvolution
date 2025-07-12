module TopModule(
    input  clk,
    input  reset,
    input  slowena,
    output [3:0] q
);

reg [3:0] state_reg;
reg [3:0] next_state;

always @(*) begin
    if (slowena) begin
        if (state_reg == 4'd9) begin
            next_state = 4'd0;
        end else begin
            next_state = state_reg + 4'd1;
        end
    end else begin
        next_state = state_reg;
    end
end

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 4'd0;
    end else begin
        state_reg <= next_state;
    end
end

assign q = state_reg;

endmodule