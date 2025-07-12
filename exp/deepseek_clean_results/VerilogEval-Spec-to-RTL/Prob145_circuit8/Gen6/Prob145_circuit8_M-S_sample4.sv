module TopModule (
    input clock,
    input a,
    output p,
    output reg q
);

// p is high only when both clock and a are high
assign p = clock & a;

// q is set when p was high in previous cycle, cleared when a is high during clock low
always @(posedge clock or posedge (a & ~clock)) begin
    if (a & ~clock)
        q <= 1'b0;  // Async clear
    else
        q <= p;     // Set based on current p (which will be latched)
end

endmodule