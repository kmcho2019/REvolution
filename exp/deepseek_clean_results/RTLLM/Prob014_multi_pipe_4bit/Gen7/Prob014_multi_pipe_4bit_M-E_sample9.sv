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
reg [1:0] cycle_count;

// Pipeline stage 2 registers
reg [7:0] accumulator;
reg [7:0] product_reg;

// Control signals
wire last_cycle = (cycle_count == 2'b11);

// Pipeline stage 1: Generate shifted multiplicands
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (integer i = 0; i < 4; i = i + 1)
            shifted_a[i] <= 8'b0;
        b_reg <= 4'b0;
        cycle_count <= 2'b0;
    end else begin
        if (cycle_count == 0) begin
            // Generate all shifted versions in parallel
            shifted_a[0] <= {4'b0, mul_a};
            shifted_a[1] <= {3'b0, mul_a, 1'b0};
            shifted_a[2] <= {2'b0, mul_a, 2'b0};
            shifted_a[3] <= {1'b0, mul_a, 3'b0};
            b_reg <= mul_b;
        end
        cycle_count <= cycle_count + 1;
    end
end

// Pipeline stage 2: Conditional accumulation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accumulator <= 8'b0;
        product_reg <= 8'b0;
    end else begin
        if (cycle_count != 0) begin
            // Accumulate if current multiplier bit is 1
            if (b_reg[cycle_count-1])
                accumulator <= accumulator + shifted_a[cycle_count-1];
            
            // Store final result at last cycle
            if (last_cycle) begin
                product_reg <= accumulator;
                accumulator <= 8'b0; // Reset for next multiplication
            end
        end
    end
end

// Output assignment
always @(*) begin
    mul_out = product_reg;
end

endmodule