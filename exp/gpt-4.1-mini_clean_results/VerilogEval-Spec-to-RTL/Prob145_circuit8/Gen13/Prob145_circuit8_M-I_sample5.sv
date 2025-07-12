module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// On posedge clock, update p based on a and current q
always @(posedge clock) begin
    p <= a | q;
end

// On negedge clock, update q based on current p
always @(negedge clock) begin
    q <= p;
end

// Optional initial block to initialize outputs
initial begin
    p = 0;
    q = 0;
end

endmodule