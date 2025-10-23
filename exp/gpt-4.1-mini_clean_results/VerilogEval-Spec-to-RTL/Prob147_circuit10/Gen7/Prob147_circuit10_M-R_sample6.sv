module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

reg next_state;

always @(*) begin
    if (b) begin
        if (a) begin
            next_state = ~state;
        end else begin
            next_state = 1'b1;
        end
    end else begin
        next_state = state;
    end
end

always @(posedge clk) begin
    state <= next_state;
end

assign q = (a & b) ? 1'b0 : state;

endmodule