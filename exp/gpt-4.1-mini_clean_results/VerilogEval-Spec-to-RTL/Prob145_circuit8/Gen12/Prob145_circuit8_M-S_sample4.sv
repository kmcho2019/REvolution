module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    always @(posedge clock) begin
        p <= a & q;
        q <= p;
    end

endmodule