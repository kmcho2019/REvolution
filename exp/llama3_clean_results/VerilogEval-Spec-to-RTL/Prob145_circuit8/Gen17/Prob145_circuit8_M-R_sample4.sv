module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg state; // 0: a has not been high, 1: a has been high for one clock cycle, 2: a has been high for two clock cycles

always @(posedge clock) begin
    if (a) begin
        if (state == 1'b1) begin
            state <= 1'b1; // 'a' is still high, no change
        end else begin
            state <= state + 1'b1; // increment state when 'a' is high
        end
    end else begin
        state <= 1'b0; // reset state when 'a' is low
    end
end

assign p = (state == 1'b1 || state == 1'b0 && a);
assign q = (state == 1'b1);

endmodule