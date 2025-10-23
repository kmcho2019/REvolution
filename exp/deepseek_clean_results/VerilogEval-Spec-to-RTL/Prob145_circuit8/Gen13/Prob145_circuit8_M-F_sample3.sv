module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// p updates on rising edge
always @(posedge clock) begin
    p <= a;
end

// q updates on falling edge
always @(negedge clock) begin
    if (a) begin
        q <= p;
    end else begin
        p <= 1'b0;
        q <= 1'b0;
    end
end

endmodule