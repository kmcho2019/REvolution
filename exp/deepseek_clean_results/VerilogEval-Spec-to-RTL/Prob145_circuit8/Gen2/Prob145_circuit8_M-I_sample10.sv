module TopModule (
    input clock,
    input a,
    output p,
    output reg q
);

reg prev_p;

// p is high only when both clock and a are high
assign p = clock & a;

// State machine for q behavior
always @(posedge clock) begin
    prev_p <= p;
    if (p) begin
        q <= 1'b1;
    end
end

// Reset condition for q (when a=1 during clock low)
always @(negedge clock) begin
    if (a) begin
        q <= 1'b0;
    end
end

endmodule