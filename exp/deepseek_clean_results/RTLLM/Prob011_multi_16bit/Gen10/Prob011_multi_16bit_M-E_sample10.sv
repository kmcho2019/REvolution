module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // Pipeline stages
    reg [1:0] stage;
    reg [15:0] areg, breg;
    reg [255:0] partial_products;  // 16x16 partial products
    reg [31:0] sum1, carry1;      // Stage 1 reduction
    reg [31:0] sum2, carry2;      // Stage 2 reduction
    
    // Generate all partial products in parallel
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage <= 2'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            partial_products <= 256'd0;
            sum1 <= 32'd0;
            carry1 <= 32'd0;
            sum2 <= 32'd0;
            carry2 <= 32'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end
        else begin
            case (stage)
                2'd0: begin  // Stage 0: Load and generate partial products
                    done <= 1'b0;
                    if (start) begin
                        areg <= ain;
                        breg <= bin;
                        // Generate all partial products
                        for (integer i = 0; i < 16; i = i + 1) begin
                            partial_products[i*16 +: 16] <= (bin & {16{ain[i]}});
                        end
                        stage <= 2'd1;
                    end
                end
                
                2'd1: begin  // Stage 1: First level reduction
                    // Carry-save add first 8 partial products
                    {sum1, carry1} <= 
                        (partial_products[15:0] << 0) +
                        (partial_products[31:16] << 1) +
                        (partial_products[47:32] << 2) +
                        (partial_products[63:48] << 3) +
                        (partial_products[79:64] << 4) +
                        (partial_products[95:80] << 5) +
                        (partial_products[111:96] << 6) +
                        (partial_products[127:112] << 7);
                    stage <= 2'd2;
                end
                
                2'd2: begin  // Stage 2: Second level reduction and final add
                    // Carry-save add remaining 8 partial products
                    {sum2, carry2} <= 
                        (partial_products[143:128] << 8) +
                        (partial_products[159:144] << 9) +
                        (partial_products[175:160] << 10) +
                        (partial_products[191:176] << 11) +
                        (partial_products[207:192] << 12) +
                        (partial_products[223:208] << 13) +
                        (partial_products[239:224] << 14) +
                        (partial_products[255:240] << 15);
                    
                    // Final parallel prefix addition
                    yout <= sum1 + carry1 + sum2 + carry2;
                    done <= 1'b1;
                    stage <= 2'd0;
                end
            endcase
        end
    end

endmodule