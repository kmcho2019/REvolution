module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;

always @(posedge clock) begin
    // p is high when current a is high at clock edge
    p <= a;
    
    // q is high when previous a was high (meaning p was high last cycle)
    // and current a is low
    q <= prev_a & ~a;
    
    // Store previous a value for next cycle
    prev_a <= a;
end

initial begin
    p = 1'b0;
    q = 1'b0;
    prev_a = 1'b0;
end

endmodule