module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

reg [1:0] priority;

always @(*) begin
    priority = 2'b00;
    if (a <= b && a <= c && a <= d) begin
        priority = 2'b11;
    end else if (b <= a && b <= c && b <= d) begin
        priority = 2'b10;
    end else if (c <= a && c <= b && c <= d) begin
        priority = 2'b01;
    end else begin
        priority = 2'b00;
    end
end

always @(*) begin
    case (priority)
        2'b11: min = a;
        2'b10: min = b;
        2'b01: min = c;
        2'b00: min = d;
    endcase
end

endmodule