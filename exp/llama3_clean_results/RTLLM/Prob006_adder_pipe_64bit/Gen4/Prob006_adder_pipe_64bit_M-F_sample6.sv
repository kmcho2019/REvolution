module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Internal registers to hold input operands
reg [63:0] reg_adda;
reg [63:0] reg_addb;

// Internal register to hold the result
reg [64:0] reg_result;

// Internal register to hold the output enable signal
reg reg_o_en;

// Assign outputs
assign result = reg_result;
assign o_en = reg_o_en;

// Main logic
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all registers
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_result <= 65'd0;
        reg_o_en <= 1'b0;
    end else begin
        if (i_en) begin
            // Capture input operands
            reg_adda <= adda;
            reg_addb <= addb;
            // Set output enable to high to indicate result is being calculated
            reg_o_en <= 1'b1;
        end else begin
            // If not enabled, reset output enable
            reg_o_en <= 1'b0;
        end
        
        // Calculate the result regardless of enable to ensure pipeline flow
        reg_result <= {1'b0, reg_adda} + {1'b0, reg_addb};
    end
end

endmodule