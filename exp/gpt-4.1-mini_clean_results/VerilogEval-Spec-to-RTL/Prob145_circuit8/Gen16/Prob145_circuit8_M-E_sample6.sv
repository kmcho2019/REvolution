module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    // On rising edge: update p based on a and previous q
    always @(posedge clock) begin
        p <= a | q;
    end

    // On falling edge: update q from current p
    always @(negedge clock) begin
        q <= p;
    end

endmodule