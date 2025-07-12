module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if(a) begin
        p <= 1'b1;
    end else begin
        p <= 1'b0;
    end
end

always @(posedge clock) begin
    if(a) begin
        q <= 1'b1;
    end else begin
        q <= q;
    end
end

always @(negedge clock) begin
    if(p) begin
        q <= 1'b1;
    end
end

endmodule