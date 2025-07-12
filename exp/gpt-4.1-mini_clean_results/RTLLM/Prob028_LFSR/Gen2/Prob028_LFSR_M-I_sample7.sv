module LFSR #(
    parameter SEED = 4'b0001
)(
    input  wire       clk,
    input  wire       rst_n,  // Active low asynchronous reset
    output reg  [3:0] out
);

    wire feedback = ~(out[3] ^ out[2]);

    // Asynchronous reset with synchronous update for clarity and better timing
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= SEED;
        end else begin
            out <= {out[2:0], feedback};
        end
    end

endmodule