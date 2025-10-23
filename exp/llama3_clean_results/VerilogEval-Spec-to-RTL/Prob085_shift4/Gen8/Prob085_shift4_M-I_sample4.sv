// TopModule: 4-bit shift register with asynchronous reset, synchronous load, and shift operations
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

// 4-bit shift register
reg [3:0] q_reg;

// Asynchronous reset
always @(posedge areset) begin
    q_reg <= 4'b0;
end

// Synchronous load and shift operations with clock gating
reg clk_enable;
always @(posedge clk) begin
    if (load || ena) begin
        clk_enable <= 1'b1;
    end else begin
        clk_enable <= 1'b0;
    end
end

always @(posedge clk) begin
    if (clk_enable) begin
        if (load) begin
            // Synchronous load with higher priority
            q_reg <= data;
        end else if (ena) begin
            // Synchronous shift right operation
            q_reg <= {1'b0, q_reg[3:1]};
        end
    end
end

// Assign output
assign q = q_reg;

endmodule