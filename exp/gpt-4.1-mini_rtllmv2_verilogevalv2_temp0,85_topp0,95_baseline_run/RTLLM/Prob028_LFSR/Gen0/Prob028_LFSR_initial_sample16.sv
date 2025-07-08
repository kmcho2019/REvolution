module LFSR (
    input  wire       clk,
    input  wire       rst,
    output reg [3:0]  out
);

    wire feedback;

    // Calculate feedback as inverted XOR of MSB and second MSB
    assign feedback = ~(out[3] ^ out[2]);

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;
        end else begin
            // Shift left and insert feedback at LSB
            out <= {out[2:0], feedback};
        end
    end

endmodule