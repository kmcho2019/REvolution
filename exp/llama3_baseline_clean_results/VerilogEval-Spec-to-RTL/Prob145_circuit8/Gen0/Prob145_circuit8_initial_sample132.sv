module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    if(a) begin
        p <= 1'b1;
        q <= 1'b1;
    end else begin
        p <= 1'b0;
        q <= 1'b0;
    end
end

always @(negedge clock) begin
    if(a) begin
        p <= p;
        q <= q;
    end else begin
        if(p && q) begin
            p <= 1'b1;
            q <= 1'b1;
        end else begin
            p <= 1'b0;
            q <= 1'b0;
        end
    end
end

endmodule