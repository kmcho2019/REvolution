module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

// Pre-calculate rotated values
wire [99:0] rotated_left;
wire [99:0] rotated_right;

genvar i;
generate
    for (i = 0; i < 100; i++) begin
        assign rotated_left[i] = (i == 0)? q_reg[99] : q_reg[i-1];
        assign rotated_right[i] = (i == 99)? q_reg[0] : q_reg[i+1];
    end
endgenerate

// Use continuous assignments to update q_reg
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena == 2'b01) begin
        q_reg <= rotated_right; // Rotate right by one bit
    end else if (ena == 2'b10) begin
        q_reg <= rotated_left; // Rotate left by one bit
    end else begin
        q_reg <= q_reg; // No rotation
    end
end

assign q = q_reg;

endmodule