module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);
    always @(posedge clock) begin
        q <= p;
        p <= a;
    end
endmodule