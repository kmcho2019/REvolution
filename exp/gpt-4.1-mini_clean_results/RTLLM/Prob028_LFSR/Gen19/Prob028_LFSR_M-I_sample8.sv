module LFSR(
    input  wire       clk,
    input  wire       rst,   // synchronous active-high reset
    output reg  [3:0] out
);

    wire feedback = ~(out[3] ^ out[2]);  // inverted XOR feedback

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;
        end else begin
            out <= {out[2:0], feedback};
        end
    end

endmodule