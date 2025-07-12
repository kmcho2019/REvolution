module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// p updates on rising clock edge based on a and q
always @(posedge clock) begin
    if (a == 1'b1) begin
        p <= 1'b1;
    end else if (q == 1'b1) begin
        p <= 1'b1;
    end else begin
        p <= 1'b0;
    end
end

// q latches p on falling clock edge
always @(negedge clock) begin
    q <= p;
end

endmodule