module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Input control
reg mul_en_out_reg;

// Input registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial product generation
wire [15:0] temp;

// Partial sum calculation
reg [15:0] sum;

// Final product calculation
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        sum <= 0;
        mul_out_reg <= 0;
    end else if (mul_en_in) begin
        // Sample input enable signal and store in register
        mul_en_out_reg <= mul_en_in;
        
        // Sample input values and store in registers
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        
        // Generate partial products
        temp <= {16{1'b0}};
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i]) begin
                temp <= temp + (mul_a_reg << i);
            end
        end
        
        // Calculate partial sums
        sum <= temp;
        
        // Calculate final product
        mul_out_reg <= sum;
    end else begin
        // Do nothing if input enable signal is inactive
    end
end

// Output assignment
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset output enable signal and product output
        mul_en_out <= 0;
        mul_out <= 0;
    end else begin
        // Assign output enable signal based on most significant bit of mul_en_out_reg
        mul_en_out <= mul_en_out_reg;
        
        // Assign product output value based on output enable signal and final product
        if (mul_en_out) begin
            mul_out <= mul_out_reg;
        end else begin
            mul_out <= 0;
        end
    end
end

endmodule