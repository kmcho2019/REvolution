module multi_16bit_pmpa(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

// Stage 1: Operand Fetch
reg [15:0] areg;
reg [15:0] breg;

// Stage 2: Shift
reg [15:0] shift_reg;
reg [4:0] shift_count;

// Stage 3: Accumulation with Parallelism
reg [31:0] accum_reg;
reg [7:0] partial_product_0;
reg [7:0] partial_product_1;
reg [7:0] partial_product_2;
reg [7:0] partial_product_3;

// Stage 4: Result
reg [31:0] result_reg;

always @(posedge clk) begin
    if (!rst_n) begin
        areg <= 16'd0;
        breg <= 16'd0;
        shift_reg <= 16'd0;
        shift_count <= 5'd0;
        accum_reg <= 32'd0;
        partial_product_0 <= 8'd0;
        partial_product_1 <= 8'd0;
        partial_product_2 <= 8'd0;
        partial_product_3 <= 8'd0;
        result_reg <= 32'd0;
        done <= 1'b0;
    end else if (start) begin
        // Fetch operands
        areg <= ain;
        breg <= bin;
        
        // Initialize shift register and count
        shift_reg <= breg;
        shift_count <= 5'd0;
        
        // Reset accumulation register
        accum_reg <= 32'd0;
        
        // Initialize partial products
        partial_product_0 <= 8'd0;
        partial_product_1 <= 8'd0;
        partial_product_2 <= 8'd0;
        partial_product_3 <= 8'd0;
    end else begin
        // Shift stage
        if (shift_count < 5'd16) begin
            shift_reg <= shift_reg << 1;
            shift_count <= shift_count + 1'b1;
        end
        
        // Accumulation stage with parallelism
        if (areg[3:0] == 4'd1) partial_product_0 <= partial_product_0 + (shift_reg[3:0] << shift_count);
        if (areg[7:4] == 4'd1) partial_product_1 <= partial_product_1 + (shift_reg[7:4] << shift_count);
        if (areg[11:8] == 4'd1) partial_product_2 <= partial_product_2 + (shift_reg[11:8] << shift_count);
        if (areg[15:12] == 4'd1) partial_product_3 <= partial_product_3 + (shift_reg[15:12] << shift_count);
        
        // Sum partial products
        accum_reg <= accum_reg + partial_product_0 + (partial_product_1 << 4) + (partial_product_2 << 8) + (partial_product_3 << 12);
        
        // Result stage
        if (shift_count == 5'd15) begin
            result_reg <= accum_reg;
            done <= 1'b1;
        end
    end
end

assign yout = result_reg;

endmodule