module DFF(
    input clk,
    input rst_n, // Active low reset
    input d,
    output reg q = 1'b0 // Initialize q to 0
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        q <= 1'b0; // Reset to 0 on active low reset
    end else begin
        q <= d;
    end
end

endmodule

module TopModule(
    input clk,
    input rst_n, // Active low reset
    input x,
    output z
);

reg xor_out, and_out, or_out; // Declare as reg to handle sequential logic
reg xor_d, and_d, or_d;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        xor_out <= 1'b0;
        and_out <= 1'b0;
        or_out <= 1'b0;
    end else begin
        xor_out <= xor_d;
        and_out <= and_d;
        or_out <= or_d;
    end
end

always @(*) begin
    xor_d = x ^ xor_out;
    and_d = x & ~and_out;
    or_d = x | ~or_out;
end

// Use a simpler gate structure at the output
assign z = ~(xor_out | and_out | or_out);

endmodule