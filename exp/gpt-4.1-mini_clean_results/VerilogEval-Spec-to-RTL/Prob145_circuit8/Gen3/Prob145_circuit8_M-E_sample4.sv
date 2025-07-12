module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Initialize outputs to zero for simulation start
initial begin
    p = 0;
    q = 0;
end

// On rising clock edge, update p only if a is high; else keep p as is
always @(posedge clock) begin
    if (a)
        p <= 1;
    else
        p <= p; // hold previous value
end

// On falling clock edge, update q to current p
always @(negedge clock) begin
    q <= p;
end

endmodule