module TopModule(
    input  clock,
    input  a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
end

always @(negedge clock) begin
    if(a) begin
        q <= 1'b1;
    end else begin
        q <= 1'b0;
    end
end

always @(negedge clock or negedge a) begin
    if(!clock && !a) begin
        p <= 1'b0;
        q <= 1'b0;
    end
end

endmodule