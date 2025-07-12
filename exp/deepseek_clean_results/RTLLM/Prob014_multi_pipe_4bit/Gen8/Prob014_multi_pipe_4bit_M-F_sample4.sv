module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Pipeline stage 1 registers
reg [7:0] shifted_a [0:3];
reg [3:0] b_reg;
reg input_valid;

// Pipeline stage 2 registers
reg [7:0] accumulator;
reg [7:0] product_reg;
reg [1:0] cycle_count;
reg accumulating;

// Generate all shifted versions of multiplicand
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (integer i = 0; i < 4; i = i + 1)
            shifted_a[i] <= 8'b0;
        b_reg <= 4'b0;
        input_valid <= 1'b0;
    end else begin
        // Capture new inputs and generate shifted versions
        if (!accumulating) begin
            shifted_a[0] <= {4'b0, mul_a};
            shifted_a[1] <= {3'b0, mul_a, 1'b0};
            shifted_a[2] <= {2'b0, mul_a, 2'b0};
            shifted_a[3] <= {1'b0, mul_a, 3'b0};
            b_reg <= mul_b;
            input_valid <= 1'b1;
        end else begin
            input_valid <= 1'b0;
        end
    end
end

// Accumulation control and execution
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accumulator <= 8'b0;
        product_reg <= 8'b0;
        cycle_count <= 2'b0;
        accumulating <= 1'b0;
    end else begin
        if (input_valid) begin
            // Start new accumulation
            accumulator <= 8'b0;
            cycle_count <= 2'b0;
            accumulating <= 1'b1;
        end else if (accumulating) begin
            // Perform accumulation step
            if (b_reg[cycle_count]) begin
                accumulator <= accumulator + shifted_a[cycle_count];
            end
            
            // Update cycle count and check for completion
            if (cycle_count == 2'd3) begin
                product_reg <= accumulator;
                accumulating <= 1'b0;
            end else begin
                cycle_count <= cycle_count + 1;
            end
        end
    end
end

// Registered output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= product_reg;
    end
end

endmodule