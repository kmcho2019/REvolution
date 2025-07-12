module TopModule(
    input  clock,
    input  a,
    output p,
    output reg q
);

reg prev_a;

always @(posedge clock) begin
    if(a) begin
        p <= 1'b1;
        prev_a <= 1'b1;
    end else begin
        p <= 1'b0;
        prev_a <= 1'b0;
    end
end

always @(negedge clock) begin
    if(prev_a) begin
        q <= 1'b1;
    end else if(!a) begin
        q <= 1'b0;
    end
end

endmodule