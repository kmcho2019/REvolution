module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out
);

    wire feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst) begin
            // Initialize to a non-zero seed to prevent lock-up at zero
            out <= 4'b0001;
        end else begin
            out <= {out[2:0], feedback};
        end
    end

endmodule