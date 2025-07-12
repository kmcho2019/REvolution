module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage 1 registers
reg [63:0] a_stage1, b_stage1;
reg [7:0] sum0 [7:0];  // Sum with carry=0 for each segment
reg [7:0] sum1 [7:0];  // Sum with carry=1 for each segment
reg [7:0] carry_prop;  // Carry propagate bits for each segment
reg en_stage1;

// Pipeline stage 2 registers
reg [63:0] selected_sum;
reg final_carry;
reg en_stage2;

// Generate segment sums (stage 1)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stage1 <= 64'b0;
        b_stage1 <= 64'b0;
        en_stage1 <= 1'b0;
        for (integer i = 0; i < 8; i = i + 1) begin
            sum0[i] <= 8'b0;
            sum1[i] <= 8'b0;
            carry_prop[i] <= 1'b0;
        end
    end else begin
        a_stage1 <= adda;
        b_stage1 <= addb;
        en_stage1 <= i_en;
        
        // Compute all segment sums in parallel
        for (integer i = 0; i < 8; i = i + 1) begin
            // Sum with carry=0
            {carry_prop[i], sum0[i]} = adda[8*i+7:8*i] + addb[8*i+7:8*i];
            
            // Sum with carry=1
            sum1[i] = adda[8*i+7:8*i] + addb[8*i+7:8*i] + 1'b1;
        end
    end
end

// Select correct sums based on carry (stage 2)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        selected_sum <= 64'b0;
        final_carry <= 1'b0;
        en_stage2 <= 1'b0;
    end else begin
        en_stage2 <= en_stage1;
        
        // First segment always uses carry=0
        selected_sum[7:0] <= sum0[0];
        reg carry = carry_prop[0];
        
        // Subsequent segments select based on previous carry
        for (integer i = 1; i < 8; i = i + 1) begin
            if (carry) begin
                selected_sum[8*i+7:8*i] <= sum1[i];
            end else begin
                selected_sum[8*i+7:8*i] <= sum0[i];
            end
            carry = carry_prop[i] | (carry & (sum0[i] != sum1[i]));
        end
        
        final_carry <= carry;
    end
end

// Final output stage (stage 3)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= {final_carry, selected_sum};
        o_en <= en_stage2;
    end
end

endmodule