module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [7:0] next_out;

    always @(posedge clk) begin
        if (reset) begin
            out <= 8'b00000001;
        end else begin
            // Circular left shift by 1: MSB wraps around to LSB
            next_out = {out[6:0], out[7]};
            out <= next_out;
        end
    end

endmodule