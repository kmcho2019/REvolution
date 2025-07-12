module TopModule(
    input clock,
    input a,
    output p,
    output reg q
);

always @(posedge clock) begin
    p = a && clock;
    if (a) begin
        q = 1'b1;
    end else begin
        q = q;
    end
end

always @(negedge clock) begin
    if (!a) begin
        q = q;
    end
end

endmodule