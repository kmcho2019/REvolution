module TopModule (
    input clock,
    input a,
    output p,
    output reg q
);

// p is high only when both clock and a are high
assign p = clock & a;

reg prev_p;  // Stores p from previous cycle

always @(posedge clock) begin
    prev_p <= p;  // Store p value for next cycle
end

// q is set when prev_p was high, cleared asynchronously when a is high during clock low
always @(posedge clock or posedge (a & ~clock)) begin
    if (a & ~clock) begin
        q <= 1'b0;  // Asynchronous clear when a is high during clock low
    end
    else begin
        q <= prev_p;  // Set based on previous p value
    end
end

endmodule