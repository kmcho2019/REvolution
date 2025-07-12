module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    // p updated on rising edge of clock based on input 'a'
    always @(posedge clock) begin
        p <= a ? 1'b1 : 1'b0;
    end

    // q updated on falling edge of clock, capturing the value of p just before falling edge
    always @(negedge clock) begin
        q <= p;
    end

endmodule