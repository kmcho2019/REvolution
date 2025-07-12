module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg clock_prev;

initial begin
    p = 1'b0;
    q = 1'b0;
    clock_prev = 1'b0;
end

always @(posedge clock or negedge clock) begin
    if (clock_prev == 1'b0 && clock == 1'b1) begin
        // Rising edge detected
        p <= a;
    end
    else if (clock_prev == 1'b1 && clock == 1'b0) begin
        // Falling edge detected
        q <= p;
    end
    clock_prev <= clock;
end

endmodule