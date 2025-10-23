module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    reg p_next;

    always @(posedge clock or negedge clock) begin
        if (clock) begin
            // Rising edge: update p based on a and current q
            p <= a & q;
        end else begin
            // Falling edge: latch p into q
            q <= p;
        end
    end

endmodule