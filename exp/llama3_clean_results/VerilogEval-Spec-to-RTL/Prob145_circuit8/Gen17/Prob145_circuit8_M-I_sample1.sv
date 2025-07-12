module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Update p at the positive edge of the clock
always @(posedge clock) begin
    p <= a;
end

// Update q at the positive edge of the clock if p is high
// and reset q at the negative edge of the clock if a is high
always @(posedge clock or negedge clock) begin
    if (~clock && a) begin
        q <= 1'b0;
    end else if (clock && p) begin
        q <= 1'b1;
    end else begin
        q <= q;
    end
end

endmodule