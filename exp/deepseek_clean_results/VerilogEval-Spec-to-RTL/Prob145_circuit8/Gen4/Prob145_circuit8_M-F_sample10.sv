module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;  // p simply follows 'a' on clock edges
end

always @(posedge clock) begin
    if (~clock && a) begin  // Clear q when a is high during clock low
        q <= 1'b0;
    end
    else begin
        q <= p;  // Otherwise q follows p with 1 cycle delay
    end
end

endmodule