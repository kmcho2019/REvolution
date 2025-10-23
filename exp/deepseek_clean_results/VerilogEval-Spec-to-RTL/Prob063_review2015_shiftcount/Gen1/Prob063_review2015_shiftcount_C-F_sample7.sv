module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire clk_enable = shift_ena | count_ena;
wire gated_clk = clk & clk_enable;

always @(posedge gated_clk) begin
    if (shift_ena) begin
        // Shift left (MSB first) and insert new data at LSB
        q <= {q[2:0], data};
    end
    else begin // count_ena must be true if we're here
        // Decrement the current value
        q <= q - 1;
    end
end

endmodule