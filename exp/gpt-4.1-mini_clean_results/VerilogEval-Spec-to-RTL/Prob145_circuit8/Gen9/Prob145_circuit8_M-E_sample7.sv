module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// Initialization
initial begin
    p = 0;
    q = 0;
end

// Update p at posedge clock based on input a and current q
always @(posedge clock) begin
    p <= a | q;
end

// Update q at negedge clock based on current p
always @(negedge clock) begin
    q <= p;
end

endmodule