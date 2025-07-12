module TopModule(
    input  clock,
    input  a,
    output reg p, // Declaring 'p' as reg to allow procedural assignment
    output reg q
);

reg prev_a;

always @(posedge clock) begin
    if(a) begin
        p <= 1'b1; // Set p to 1 when a is 1 and clock is high
        prev_a <= 1'b1;
    end else begin
        p <= 1'b0; // Set p to 0 when a is 0 and clock is high
        prev_a <= 1'b0;
    end
end

always @(negedge clock) begin
    if(prev_a) begin
        q <= 1'b1; // Set q to 1 when prev_a is 1 at the negative edge of the clock
    end else if(!a) begin
        q <= 1'b0; // Reset q to 0 if a is 0 at the negative edge of the clock
    end
end

endmodule