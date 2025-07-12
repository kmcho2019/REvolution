module Counter(
    input clk,
    input reset,
    output [9:0] count
);

parameter WIDTH = 10;

reg [WIDTH-1:0] shift_register;

always @(posedge clk) begin
    if (reset) begin
        shift_register <= 'd0;
    end else if (shift_register == 10'd999) begin
        shift_register <= 'd0;
    end else begin
        shift_register <= shift_register + 1'b1;
    end
end

assign count = shift_register;

endmodule

module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

Counter counter_instance(
   .clk(clk),
   .reset(reset),
   .count(q)
);

endmodule