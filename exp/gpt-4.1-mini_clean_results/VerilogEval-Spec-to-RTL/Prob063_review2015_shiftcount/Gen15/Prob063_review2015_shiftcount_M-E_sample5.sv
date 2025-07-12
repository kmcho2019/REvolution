module TopModule (
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

// Optional asynchronous reset for safe initialization, tied low if unused
input async_rst;

always @(posedge clk or posedge async_rst) begin
    if (async_rst) begin
        q <= 4'b0000;
    end else begin
        if (shift_ena) begin
            // Shift left, load new MSB data
            q <= {data, q[3:1]};
        end else if (count_ena) begin
            // Decrement with wrap-around (mod 16)
            q <= q - 4'd1;
        end else begin
            // Hold current value
            q <= q;
        end
    end
end

endmodule