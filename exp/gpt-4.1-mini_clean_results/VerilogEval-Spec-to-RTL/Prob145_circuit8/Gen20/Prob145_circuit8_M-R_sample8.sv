module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg clock_d; // delayed clock to detect edges

always @(posedge clock) begin
    p <= a;          // on rising edge, p follows a
    clock_d <= 1'b1; // remember clock high
end

always @(posedge clock or negedge clock) begin
    if (clock == 1'b0 && clock_d == 1'b1) begin
        // falling edge detected
        q <= p;
        clock_d <= 1'b0;
    end
end

initial begin
    clock_d = 0;
end

endmodule