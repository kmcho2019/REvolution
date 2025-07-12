module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline control
    reg [2:0] en_pipe;
    assign mul_en_out = en_pipe[2];

    // Early zero detection
    wire zero_operand = (mul_a == 8'b0) || (mul_b == 8'b0);
    
    // Stage 1: Booth Encoding
    reg [8:0] a_ext;
    reg [8:0] neg_a_ext;
    reg [3:0] booth_sel;
    reg zero_detect;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_ext <= 9'b0;
            neg_a_ext <= 9'b0;
            booth_sel <= 4'b0;
            zero_detect <= 1'b0;
            en_pipe[0] <= 1'b0;
        end else if (mul_en_in) begin
            a_ext <= {mul_a[7], mul_a};
            neg_a_ext <= {~mul_a[7], ~mul_a} + 1;
            
            // Booth encoding (radix-4)
            booth_sel[0] <= (mul_b[1:0] == 2'b01) || (mul_b[1:0] == 2'b10);
            booth_sel[1] <= (mul_b[3:1] == 3'b001) || (mul_b[3:1] == 3'b010);
            booth_sel[2] <= (mul_b[5:3] == 3'b001) || (mul_b[5:3] == 3'b010);
            booth_sel[3] <= (mul_b[7:5] == 3'b001) || (mul_b[7:5] == 3'b010);
            
            zero_detect <= zero_operand;
            en_pipe[0] <= mul_en_in;
        end else begin
            en_pipe[0] <= 1'b0;
        end
    end

    // Stage 1: Partial Product Generation
    wire [10:0] pp0 = booth_sel[0] ? 
                      (mul_b[1] ? {neg_a_ext, 2'b0} : {a_ext, 2'b0}) : 11'b0;
    wire [12:0] pp1 = booth_sel[1] ? 
                      (mul_b[3] ? {3'b111, neg_a_ext} : {3'b000, a_ext}) : 13'b0;
    wire [14:0] pp2 = booth_sel[2] ? 
                      (mul_b[5] ? {5'b11111, neg_a_ext} : {5'b00000, a_ext}) : 15'b0;
    wire [16:0] pp3 = booth_sel[3] ? 
                      (mul_b[7] ? {7'b1111111, neg_a_ext} : {7'b0000000, a_ext}) : 17'b0;

    // Stage 2: Wallace Tree Reduction (3:2 compressors)
    reg [16:0] sum1, carry1;
    reg zero_detect_stage2;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum1 <= 17'b0;
            carry1 <= 17'b0;
            zero_detect_stage2 <= 1'b0;
            en_pipe[1] <= 1'b0;
        end else if (en_pipe[0]) begin
            // First level compression
            {carry1[15:0], sum1[15:0]} = pp0 + pp1[15:0] + pp2[15:0];
            carry1[16] = pp3[16];
            sum1[16] = pp3[15];
            
            zero_detect_stage2 <= zero_detect;
            en_pipe[1] <= en_pipe[0];
        end else begin
            en_pipe[1] <= 1'b0;
        end
    end

    // Stage 3: Final Addition
    reg [15:0] result;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 16'b0;
            en_pipe[2] <= 1'b0;
        end else if (en_pipe[1]) begin
            if (zero_detect_stage2) begin
                result <= 16'b0;
            end else begin
                result <= sum1[15:0] + (carry1[15:0] << 1);
            end
            en_pipe[2] <= en_pipe[1];
        end else begin
            en_pipe[2] <= 1'b0;
        end
    end

    assign mul_out = en_pipe[2] ? result : 16'b0;

endmodule