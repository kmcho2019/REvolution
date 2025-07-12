module multi_pipe_8bit (
    input  clk, 
    input  rst_n, 
    input  mul_en_in, 
    input  [7:0] mul_a, 
    input  [7:0] mul_b, 
    output [15:0] mul_out, 
    output mul_en_out
);

reg [0:0] mul_en_out_reg; // Store the input enable signal
reg [7:0] mul_a_reg; // Register for multiplicand
reg [7:0] mul_b_reg; // Register for multiplier
reg [15:0] mul_out_reg; // Register for final product
wire [15:0] temp; // Wires for partial products
reg [15:0] sum; // Register for partial sum

// Input control and registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1'b1;
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

// Partial product generation
assign temp[0] = (mul_b[0] == 1'b1) ? mul_a : 8'b0;
assign temp[8] = (mul_b[1] == 1'b1) ? {mul_a, 1'b0} : 9'b0;
assign temp[1*8 + 1] = (mul_b[2] == 1'b1) ? {mul_a, 2'b0} : 10'b0;
assign temp[2*8 + 2] = (mul_b[3] == 1'b1) ? {mul_a, 3'b0} : 11'b0;
assign temp[3*8 + 3] = (mul_b[4] == 1'b1) ? {mul_a, 4'b0} : 12'b0;
assign temp[4*8 + 4] = (mul_b[5] == 1'b1) ? {mul_a, 5'b0} : 13'b0;
assign temp[5*8 + 5] = (mul_b[6] == 1'b1) ? {mul_a, 6'b0} : 14'b0;
assign temp[6*8 + 6] = (mul_b[7] == 1'b1) ? {mul_a, 7'b0} : 15'b0;

// Partial sum calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 16'b0;
    end else if (mul_en_out_reg == 1'b1) begin
        sum <= sum + temp;
    end else begin
        sum <= 16'b0;
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (mul_en_out_reg == 1'b1) begin
        mul_out_reg <= sum;
    end else begin
        mul_out_reg <= 16'b0;
    end
end

// Output assignment
assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg == 1'b1) ? mul_out_reg : 16'b0;

endmodule