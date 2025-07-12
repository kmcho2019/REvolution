module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state;
reg [31:0] bits_seen;
reg [31:0] inverted_bits;
reg is_first_bit;

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        bits_seen <= 0;
        inverted_bits <= 0;
        is_first_bit <= 1;
        z <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (~areset) begin
                    state <= 1;
                    bits_seen <= 0;
                    inverted_bits <= 0;
                    is_first_bit <= 1;
                    z <= 0;
                end
            end
            1: begin // CONVERT
                if (is_first_bit) begin
                    bits_seen <= x;
                    inverted_bits <= ~x;
                    is_first_bit <= 0;
                    z <= ~x;
                end else begin
                    bits_seen <= {bits_seen[30:0], x};
                    inverted_bits <= {inverted_bits[30:0], ~x};
                    z <= ~bits_seen[0] + bits_seen[31] + 1;
                end
                if (areset) begin
                    state <= 0;
                    bits_seen <= 0;
                    inverted_bits <= 0;
                    is_first_bit <= 1;
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule