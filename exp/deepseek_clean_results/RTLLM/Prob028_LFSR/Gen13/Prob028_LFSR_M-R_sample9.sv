module LFSR (
    input  wire clk,
    input  wire rst,
    output reg  [3:0] out
);

// Combinational feedback calculation
wire feedback;
assign feedback = ~(out[3] ^ out[2]);

// Sequential state update
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;  // Synchronous reset
    end else begin
        out <= {out[2:0], feedback};  // Shift left and insert feedback
    end
end

endmodule