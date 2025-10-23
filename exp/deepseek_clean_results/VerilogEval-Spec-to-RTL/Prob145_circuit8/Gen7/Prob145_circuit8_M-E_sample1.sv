module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;
reg p_prev;

always @(posedge clock) begin
    p <= a;          // p takes value of a at rising edge
    a_prev <= a;     // Remember a at rising edge
end

always @(negedge clock) begin
    p <= 1'b0;       // Clear p at falling edge
    if (p_prev) begin
        q <= 1'b1;   // Set q if p was high before falling edge
    end
    else if (~a) begin
        q <= 1'b0;   // Clear q if a is low during clock low
    end
    p_prev <= p;     // Remember p state before falling edge
end

endmodule