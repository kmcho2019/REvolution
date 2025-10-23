module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;

always @(posedge clock) begin
    a_prev <= a;  // Store previous a value
    
    // p is high when current a is high and previous a was low
    p <= a & ~a_prev;
    
    // q is set if p was high last cycle, cleared if a is low
    if (p) begin
        q <= 1'b1;
    end
    else if (~a) begin
        q <= 1'b0;
    end
end

endmodule