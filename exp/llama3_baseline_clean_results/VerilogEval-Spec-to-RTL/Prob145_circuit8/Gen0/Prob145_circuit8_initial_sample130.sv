module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if(a)
        q <= 1'b1;
    else
        q <= q;
end

always @(posedge clock or negedge clock) begin
    if(clock && a)
        p <= 1'b1;
    else if(clock == 1'b0)
        p <= 1'b0;
    else
        p <= 0;
end

endmodule