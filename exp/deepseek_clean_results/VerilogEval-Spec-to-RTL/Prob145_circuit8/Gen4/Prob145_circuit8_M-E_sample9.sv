module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if (a) begin
        p <= 1'b1;
    end
end

always @(negedge clock) begin
    if (a) begin
        // Reset condition
        p <= 1'b0;
        q <= 1'b0;
    end else begin
        // Normal operation
        p <= 1'b0;
        q <= p;
    end
end

endmodule