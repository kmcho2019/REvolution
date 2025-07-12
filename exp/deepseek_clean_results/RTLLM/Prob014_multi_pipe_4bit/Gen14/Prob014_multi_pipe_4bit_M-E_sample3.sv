module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extended inputs with size zeros at MSB
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

// Pipeline stage 1: Shifted multiplicand generation
reg [2*size-1:0] shifted_a [0:size-1];
reg [size-1:0] b_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (integer i = 0; i < size; i = i + 1)
            shifted_a[i] <= '0;
        b_reg <= '0;
    end else begin
        b_reg <= mul_b;
        for (integer i = 0; i < size; i = i + 1)
            shifted_a[i] <= ext_a << i;
    end
end

// Pipeline stage 2: Carry-save accumulation
reg [2*size-1:0] sum;
reg [2*size-1:0] carry;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= '0;
        carry <= '0;
    end else begin
        // Reset accumulation for new calculation
        if (b_reg != mul_b) begin
            sum <= '0;
            carry <= '0;
        end
        else begin
            // Carry-save addition tree
            for (integer i = 0; i < size; i = i + 1) begin
                if (b_reg[i]) begin
                    {carry, sum} <= sum + carry + shifted_a[i];
                end
            end
        end
    end
end

// Final addition and output registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= '0;
    end else begin
        mul_out <= sum + carry;
    end
end

endmodule