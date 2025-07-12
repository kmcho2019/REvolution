module TopModule(
    input         clk,
    input         rst_n,       // Active low synchronous reset added for better initialization and gating
    input         shift_ena,
    input         count_ena,
    input         data,
    output reg [3:0] q
);

// Shift register update on shift_ena only
always @(posedge clk) begin
    if (!rst_n) begin
        q <= 4'b0;
    end
    else if (shift_ena) begin
        // Shift data in MSB first: new data goes to MSB, shift right
        q <= {data, q[3:1]};
    end
end

// Counter decrement update on count_ena only
always @(posedge clk) begin
    if (!rst_n) begin
        q <= 4'b0;
    end
    else if (count_ena) begin
        // Decrement q by 1 with wrap-around (q - 1 mod 16)
        q <= q + 4'b1111;
    end
end

endmodule