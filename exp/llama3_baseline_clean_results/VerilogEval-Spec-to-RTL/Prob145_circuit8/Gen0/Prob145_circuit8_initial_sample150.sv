module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;
end

always @(posedge clock or negedge clock) begin
    if (clock == 1'b0 && a == 1'b0) begin
        q <= p;
    end else if (clock == 1'b1 && a == 1'b1) begin
        q <= 1'b1;
    end
end

endmodule