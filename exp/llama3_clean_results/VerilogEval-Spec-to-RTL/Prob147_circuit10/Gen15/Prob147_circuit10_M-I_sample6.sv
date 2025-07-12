module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    if (~a && b) begin
        state <= 1'b1;
    end else if (a && b && state) begin
        state <= 1'b0;
    end else begin
        // Hold the current state if none of the above conditions are met
        state <= state;
    end
end

always @(*) begin
    // 'q' is 1 when the state is 1 or when 'a' is 1 and 'b' is 0
    q = state || (a && ~b);
end

endmodule