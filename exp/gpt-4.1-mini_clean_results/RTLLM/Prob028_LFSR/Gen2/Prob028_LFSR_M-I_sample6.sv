module LFSR #(
    parameter WIDTH = 4,
    parameter [WIDTH-1:0] SEED = 4'b0001
) (
    input  wire              clk,
    input  wire              rst_n, // Active low asynchronous reset
    output logic [WIDTH-1:0] out
);

    localparam MSB = WIDTH - 1;
    localparam TAP = WIDTH - 2;

    wire feedback = ~(out[MSB] ^ out[TAP]);

    // Asynchronous reset, synchronous shift
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            out <= SEED;
        else
            out <= {out[MSB-1:0], feedback};
    end

endmodule