module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Zero detection signals
    wire a_zero = (a == 32'b0);
    wire b_zero = (b == 32'b0);
    wire skip_cycle = a_zero | b_zero;

    // Pipeline Stage 1: Booth Encoding and Partial Product Generation
    reg signed [33:0] a_ext;
    reg signed [33:0] b_ext;
    wire signed [67:0] partial_products [16:0];
    
    always @(posedge clk) begin
        if (rst) begin
            a_ext <= 34'b0;
            b_ext <= 34'b0;
        end else begin
            // Sign extend with 2 guard bits
            a_ext <= {a[31], a[31], a};
            b_ext <= {b[31], b[31], b};
        end
    end

    // Booth Radix-4 Encoder (generates 17 partial products)
    genvar i;
    generate
        for (i = 0; i < 17; i = i + 1) begin : booth_pp
            // Booth encoding logic (simplified for brevity)
            wire [1:0] sel = b_ext[i*2 +: 2];
            wire neg = sel[1];
            wire [33:0] pp = (sel == 2'b01) ? a_ext :
                            (sel == 2'b10) ? -a_ext :
                            (sel == 2'b11) ? -(a_ext << 1) :
                            (a_ext << 1);
            assign partial_products[i] = {{(34-2*i){pp[33]}}, pp, {2*i{1'b0}}};
        end
    endgenerate

    // Pipeline Stage 2: Wallace Tree Reduction and Carry-Save Accumulation
    reg signed [63:0] product_cs;  // Carry-save sum
    reg signed [63:0] product_cc;  // Carry-save carry
    reg signed [31:0] acc_reg;

    always @(posedge clk) begin
        if (rst) begin
            product_cs <= 64'b0;
            product_cc <= 64'b0;
            acc_reg <= 32'b0;
            c <= 32'b0;
        end else begin
            // Wallace tree reduction (simplified to 2:1 CSA)
            if (skip_cycle) begin
                product_cs <= 64'b0;
                product_cc <= 64'b0;
            end else begin
                // First level compression (in real design would have more levels)
                product_cs <= partial_products[0] + partial_products[1];
                product_cc <= (partial_products[0] & partial_products[1]) << 1;
            end

            // Carry-save accumulation (sum + carry + previous accumulator)
            {product_cc, acc_reg} <= {32'b0, acc_reg} + product_cs + product_cc;
            
            // Final output (carry propagate only here)
            c <= acc_reg + product_cs[31:0] + product_cc[31:0];
        end
    end

endmodule