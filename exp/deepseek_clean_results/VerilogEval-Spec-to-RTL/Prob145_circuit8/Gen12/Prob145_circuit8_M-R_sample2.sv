module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg p_reg, q_reg;
wire clock_high, clock_low;

// Clock phase detection
assign clock_high = clock;
assign clock_low = ~clock;

// p behavior - updates during clock high
always @(posedge clock_high) begin
    p_reg <= a;
end

// q behavior - updates during clock low
always @(posedge clock_low) begin
    if (~a) begin
        q_reg <= 1'b0;
    end else begin
        q_reg <= p_reg;
    end
end

// Clear condition for p during clock low
assign p = (clock_low & ~a) ? 1'b0 : p_reg;
assign q = q_reg;

endmodule