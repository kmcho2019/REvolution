module LFSR (
    input  wire       clk,
    input  wire       rst,      // Active high synchronous reset
    output reg  [3:0] out
);

    reg feedback;

    // Combinational logic to calculate feedback
    always @(*) begin
        feedback = ~(out[3] ^ out[2]);
    end

    // Sequential logic to update LFSR state
    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;  // Reset state
        end else begin
            out <= {out[2:0], feedback};  // Shift left, insert feedback at LSB
        end
    end

endmodule