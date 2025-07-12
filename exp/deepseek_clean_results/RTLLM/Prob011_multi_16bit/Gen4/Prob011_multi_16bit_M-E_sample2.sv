module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

// Pipeline registers
reg [1:0] stage;
reg [15:0] a_reg, b_reg;
reg zero_flag;

// Booth encoding signals
wire [16:0] a_ext = {1'b0, ain};
wire [16:0] neg_a = ~a_ext + 1;
wire [16:0] a_x2 = a_ext << 1;
wire [16:0] neg_a_x2 = ~a_x2 + 1;

// Partial product generation
reg [16:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7;

// Carry-save reduction signals
wire [31:0] sum1, carry1;
wire [31:0] sum2, carry2;
wire [31:0] sum_final;

// Control logic
assign done = (stage == 2'd2);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage <= 2'd0;
        a_reg <= 16'd0;
        b_reg <= 16'd0;
        zero_flag <= 1'b0;
        yout <= 32'd0;
    end else begin
        case (stage)
            2'd0: begin // Stage 1: Input and Booth encoding
                if (start) begin
                    a_reg <= ain;
                    b_reg <= bin;
                    zero_flag <= (ain == 16'd0) || (bin == 16'd0);
                    
                    // Generate partial products
                    pp0 <= booth_product(ain, bin[1:0]);
                    pp1 <= booth_product(ain, bin[3:1]) << 2;
                    pp2 <= booth_product(ain, bin[5:3]) << 4;
                    pp3 <= booth_product(ain, bin[7:5]) << 6;
                    pp4 <= booth_product(ain, bin[9:7]) << 8;
                    pp5 <= booth_product(ain, bin[11:9]) << 10;
                    pp6 <= booth_product(ain, bin[13:11]) << 12;
                    pp7 <= booth_product(ain, bin[15:13]) << 14;
                    
                    stage <= 2'd1;
                end
            end
            
            2'd1: begin // Stage 2: Carry-save reduction
                if (zero_flag) begin
                    yout <= 32'd0;
                    stage <= 2'd2;
                end else begin
                    // First level 4:2 compression
                    {sum1, carry1} = compressor4to2(pp0, pp1, pp2, pp3);
                    // Second level 4:2 compression
                    {sum2, carry2} = compressor4to2(pp4, pp5, pp6, pp7);
                    stage <= 2'd2;
                end
            end
            
            2'd2: begin // Stage 3: Final addition
                if (!zero_flag) begin
                    sum_final = sum1 + sum2 + carry1 + carry2;
                    yout <= sum_final;
                end
                stage <= 2'd0;
            end
        endcase
    end
end

// Booth encoder function
function [16:0] booth_product;
    input [15:0] a;
    input [2:0] b_group;
    begin
        case (b_group)
            3'b000, 3'b111: booth_product = 17'd0;
            3'b001, 3'b010: booth_product = {1'b0, a};
            3'b011:         booth_product = a << 1;
            3'b100:         booth_product = ~(a << 1) + 1;
            3'b101, 3'b110: booth_product = ~{1'b0, a} + 1;
        endcase
    end
endfunction

// 4:2 compressor function
function [63:0] compressor4to2;
    input [16:0] a, b, c, d;
    reg [16:0] s, co;
    begin
        // Bitwise compression
        for (integer i=0; i<17; i=i+1) begin
            s[i] = a[i] ^ b[i] ^ c[i] ^ d[i];
            co[i] = (a[i] & b[i]) | (c[i] & d[i]) | 
                   ((a[i] | b[i]) & (c[i] | d[i]));
        end
        compressor4to2 = {s, {co[15:0], 1'b0}}; // Shift carry left
    end
endfunction

endmodule