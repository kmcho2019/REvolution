module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
    );

    always @(posedge clock) begin
        p <= a;
        q <= a;
    end

    always @(negedge clock) begin
        q <= p;
    end

endmodule