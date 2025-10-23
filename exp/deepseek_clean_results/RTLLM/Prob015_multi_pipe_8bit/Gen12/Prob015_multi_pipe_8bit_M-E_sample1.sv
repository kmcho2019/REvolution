module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 1: Input registration and Booth encoding
    reg [7:0] mul_a_s1, mul_b_s1;
    reg en_s1;
    wire [8:0] booth_b = {mul_b_s1, 1'b0}; // Extended for Booth encoding
    
    // Booth encoder outputs (4 partial products)
    wire [8:0] booth_sel [3:0];
    assign booth_sel[0] = {1'b0, booth_b[1:0], 6'b0};
    assign booth_sel[1] = {1'b0, booth_b[3:1], 5'b0};
    assign booth_sel[2] = {1'b0, booth_b[5:3], 4'b0};
    assign booth_sel[3] = {1'b0, booth_b[7:5], 3'b0};
    
    // Pipeline stage 2: Partial product generation and compression
    reg [15:0] pp [3:0];
    reg en_s2;
    
    // Generate partial products based on Booth encoding
    always @(*) begin
        for (integer i = 0; i < 4; i = i + 1) begin
            case (booth_sel[i][2:0])
                3'b000, 3'b111: pp[i] = 16'b0;
                3'b001, 3'b010: pp[i] = {8'b0, mul_a_s1} << (2*i);
                3'b011:         pp[i] = {7'b0, mul_a_s1, 1'b0} << (2*i);
                3'b100:         pp[i] = ~({7'b0, mul_a_s1, 1'b0} << (2*i)) + 1;
                3'b101, 3'b110: pp[i] = ~({8'b0, mul_a_s1} << (2*i)) + 1;
            endcase
        end
    end
    
    // Carry-save adder structure
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;
    
    // First level of CSA
    assign {carry1, sum1} = pp[0] + pp[1];
    assign {carry2, sum2} = pp[2] + pp[3];
    
    // Pipeline stage 3: Final addition and output
    reg [15:0] final_sum;
    reg en_s3;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            mul_a_s1 <= 8'b0;
            mul_b_s1 <= 8'b0;
            en_s1 <= 1'b0;
            en_s2 <= 1'b0;
            final_sum <= 16'b0;
            en_s3 <= 1'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Pipeline stage 1
            mul_a_s1 <= mul_a;
            mul_b_s1 <= mul_b;
            en_s1 <= mul_en_in;
            
            // Pipeline stage 2
            en_s2 <= en_s1;
            
            // Pipeline stage 3: Final addition (sum1 + carry1 + sum2 + carry2)
            final_sum <= (sum1 + carry1) + (sum2 + carry2);
            en_s3 <= en_s2;
            
            // Output
            mul_en_out <= en_s3;
            mul_out <= final_sum;
        end
    end

endmodule