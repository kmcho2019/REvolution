module TopModule (
    input           clk,
    input           areset,
    input           load,
    input           ena,
    input   [3:0]    data,
    output  [3:0]    q
);

// 4-bit shift register
reg [3:0] q_reg;

// Asynchronous reset, synchronous load and shift operations
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        q_reg <= 4'b0;
    end else if (load) begin
        // Synchronous load with higher priority
        q_reg <= data;
    end else if (ena) begin
        // Synchronous shift right operation
        q_reg <= {1'b0, q_reg[3:1]};
    end
end

// Assign output
assign q = q_reg;

endmodule