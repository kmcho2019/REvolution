module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_a;
reg prev_clock;

always @(posedge clock or negedge clock) begin
    prev_a <= a;
    prev_clock <= clock;
end

always @(posedge clock) begin
    if(a) begin
        p <= 1'b1;
    end else begin
        p <= 1'b0;
    end
end

always @(negedge clock) begin
    if(prev_a && prev_clock) begin
        q <= 1'b1;
    end else if(!prev_a) begin
        q <= 1'b0;
    end
end

initial begin
    p = 1'b0;
    q = 1'b0;
    prev_a = 1'b0;
    prev_clock = 1'b0;
end

endmodule