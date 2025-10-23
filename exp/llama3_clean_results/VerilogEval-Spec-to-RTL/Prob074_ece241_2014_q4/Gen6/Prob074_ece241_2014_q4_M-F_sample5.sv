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

reg xor_out = 1'b0, and_out = 1'b0, or_out = 1'b0;
reg reset = 1'b1;

always @(posedge clk) begin
    if (reset) begin
        xor_out <= 1'b0;
        and_out <= 1'b0;
        or_out <= 1'b0;
        reset <= 1'b0;
    end else begin
        xor_out <= x ^ xor_out;
        and_out <= x & ~and_out;
        or_out <= x | ~or_out;
    end
    z <= ~(xor_out | and_out | or_out);
end

endmodule