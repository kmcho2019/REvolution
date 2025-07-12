module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;  // p simply follows 'a' at positive edges
end

always @(negedge clock) begin
    if (a) begin
        q <= p;  // q follows p when 'a' is high at negative edge
    end else begin
        q <= 1'b0;  // q clears when 'a' is low at negative edge
    end
end

initial begin
    p = 1'b0;
    q = 1'b0;
end

endmodule