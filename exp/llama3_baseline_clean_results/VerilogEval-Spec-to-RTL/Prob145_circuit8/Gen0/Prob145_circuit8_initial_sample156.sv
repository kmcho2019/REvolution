module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_detected;

always @(posedge clock) begin
    p <= 0;
    if(a) begin
        a_detected <= 1;
        p <= 1;
    end
end

always @(negedge clock) begin
    a_detected <= 0;
end

always @(*) begin
    if(clock) begin
        q <= 0;
    end else begin
        q <= a_detected;
    end
end

endmodule