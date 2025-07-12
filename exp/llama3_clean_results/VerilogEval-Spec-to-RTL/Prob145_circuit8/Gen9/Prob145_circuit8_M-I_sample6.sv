module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;
reg p_high;
reg q_high;

always @(posedge clock) begin
    prev_a <= a;
    if (a && !prev_a) begin
        p_high <= 1'b1;
    end else if (!a && prev_a) begin
        p_high <= 1'b0;
    end
end

always @(negedge clock) begin
    if (a && prev_a) begin
        q_high <= 1'b1;
    end else if (!a && prev_a) begin
        q_high <= 1'b0;
    end
end

assign p = p_high;
assign q = q_high;

endmodule