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
    output reg z
);

reg reset = 1'b1;
reg xor_out, and_out, or_out;

xor_dff u_xor_dff(clk, reset, x, xor_out);
and_dff u_and_dff(clk, reset, x, and_out);
or_dff u_or_dff(clk, reset, x, or_out);

always @(posedge clk) begin
    if (reset) begin
        reset <= 1'b0;
    end
    z <= ~(xor_out | and_out | or_out);
end

endmodule