module xor_dff(
    input clk,
    input reset,
    input x,
    output reg y
);

always @(posedge clk) begin
    if (reset) begin
        y <= 1'b0;
    end else begin
        y <= x ^ y;
    end
end

endmodule

module and_dff(
    input clk,
    input reset,
    input x,
    output reg y
);

always @(posedge clk) begin
    if (reset) begin
        y <= 1'b0;
    end else begin
        y <= x & ~y;
    end
end

endmodule

module or_dff(
    input clk,
    input reset,
    input x,
    output reg y
);

always @(posedge clk) begin
    if (reset) begin
        y <= 1'b0;
    end else begin
        y <= x | ~y;
    end
end

endmodule

module TopModule(
    input clk,
    input x,
    input reset,
    output reg z
);

reg xor_out, and_out, or_out;

xor_dff u_xor(.clk(clk),.reset(reset),.x(x),.y(xor_out));
and_dff u_and(.clk(clk),.reset(reset),.x(x),.y(and_out));
or_dff u_or(.clk(clk),.reset(reset),.x(x),.y(or_out));

always @(*) begin
    z = ~(xor_out | and_out | or_out);
end

endmodule