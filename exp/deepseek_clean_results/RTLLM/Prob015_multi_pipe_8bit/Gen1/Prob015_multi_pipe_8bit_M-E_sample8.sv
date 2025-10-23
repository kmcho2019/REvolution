module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers
    reg [7:0] a_reg, b_reg;
    reg [2:0] en_pipeline;
    
    // Booth encoded partial products
    wire [8:0] pp [3:0];
    reg [8:0] pp_reg [3:0];
    
    // Wallace tree reduction stage
    wire [15:0] sum1, carry1;
    reg [15:0] sum1_reg, carry1_reg;
    
    // Final result
    reg [15:0] result_reg;
    
    // Booth encoder (radix-4)
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : booth
            wire [1:0] sel = b_reg[(i*2)+1:i*2];
            wire [8:0] a_ext = {a_reg[7], a_reg}; // sign-extended
            
            assign pp[i] = (sel == 2'b01) ? a_ext :
                          (sel == 2'b10) ? ~a_ext + 1 :
                          (sel == 2'b11) ? {a_ext[7:0], 1'b0} : 9'b0;
        end
    endgenerate
    
    // Input stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            en_pipeline <= 3'b0;
        end else begin
            if (mul_en_in) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end
    
    // Pipeline stage 1: Register partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp_reg[0] <= 9'b0;
            pp_reg[1] <= 9'b0;
            pp_reg[2] <= 9'b0;
            pp_reg[3] <= 9'b0;
        end else if (en_pipeline[0]) begin
            // Shift partial products according to their weight
            pp_reg[0] <= pp[0];
            pp_reg[1] <= {pp[1], 1'b0};
            pp_reg[2] <= {pp[2], 2'b0};
            pp_reg[3] <= {pp[3], 3'b0};
        end
    end
    
    // Pipeline stage 2: Wallace tree reduction (3:2 compressors)
    assign {carry1, sum1} = 
        ({7'b0, pp_reg[0]} + {5'b0, pp_reg[1], 2'b0}) + 
        ({3'b0, pp_reg[2], 4'b0} + {1'b0, pp_reg[3], 6'b0});
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum1_reg <= 16'b0;
            carry1_reg <= 16'b0;
        end else if (en_pipeline[1]) begin
            sum1_reg <= sum1;
            carry1_reg <= carry1;
        end
    end
    
    // Pipeline stage 3: Final addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_reg <= 16'b0;
        end else if (en_pipeline[2]) begin
            result_reg <= sum1_reg + carry1_reg;
        end
    end
    
    // Output assignment
    assign mul_en_out = en_pipeline[2];
    assign mul_out = mul_en_out ? result_reg : 16'b0;

endmodule