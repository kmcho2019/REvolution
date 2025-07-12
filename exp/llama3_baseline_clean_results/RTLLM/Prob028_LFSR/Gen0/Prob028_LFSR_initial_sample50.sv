module LFSR (
    input clk,      // Clock signal
    input rst,      // Active high reset signal
    output reg [3:0] out  // 4-bit output
);

// Calculate the feedback signal
assign feedback = ~(out[3] ^ out[2]);

// Always block for sequential logic
always @ (posedge clk) begin
    if (rst) begin  // If reset is high, initialize the register
        out <= 4'b0;
    end else begin  // Otherwise, shift the register and insert feedback
        out <= {out[2:0], feedback};
    end
end

endmodule