module LFSR #(
    parameter WIDTH = 4
) (
    input clk,
    input rst,
    output reg [WIDTH-1:0] out
);

reg feedback;

always @(posedge clk) begin
    if (rst) begin
        out <= {WIDTH{1'b0}};  // Reset to all zeros
        feedback <= 1'b0;
    end
    else begin
        // Calculate feedback using XNOR (equivalent to ~(out[3]^out[2]))
        feedback <= ~(out[WIDTH-1] ^ out[WIDTH-2]);
        
        // Shift register with feedback
        out <= {out[WIDTH-2:0], feedback};
    end
end

endmodule