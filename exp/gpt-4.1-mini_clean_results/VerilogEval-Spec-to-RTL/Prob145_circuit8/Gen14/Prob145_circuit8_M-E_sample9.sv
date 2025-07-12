module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Initialize states to zero
initial begin
    p = 0;
    q = 0;
end

// p updates on rising clock edge with conditional logic to hold or set state
always @(posedge clock) begin
    if (a == 1'b1) begin
        p <= 1'b1;
    end else begin
        if (q == 1'b1)
            p <= 1'b0;
        else
            p <= p; // hold p state
    end
end

// q latches p on falling clock edge
always @(negedge clock) begin
    q <= p;
end

endmodule