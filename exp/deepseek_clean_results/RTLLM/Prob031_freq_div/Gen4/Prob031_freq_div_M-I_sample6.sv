module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Gray code counter for 10MHz clock (divide by 10)
    reg [2:0] cnt_10_gray;
    wire [2:0] cnt_10_binary;
    
    // Down counter for 1MHz clock (divide by 100)
    reg [6:0] cnt_100;
    wire cnt_100_terminal;

    // Gray to binary conversion for cnt_10
    assign cnt_10_binary = {cnt_10_gray[2], 
                           cnt_10_gray[2] ^ cnt_10_gray[1], 
                           cnt_10_gray[1] ^ cnt_10_gray[0]};

    // Terminal count detection for cnt_100 (when all bits are 1)
    assign cnt_100_terminal = &cnt_100;

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10_gray <= 3'b0;
        end else begin
            if (cnt_10_binary == 3'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10_gray <= 3'b0;
            end else begin
                // Gray code increment
                case (cnt_10_gray)
                    3'b000: cnt_10_gray <= 3'b001;
                    3'b001: cnt_10_gray <= 3'b011;
                    3'b011: cnt_10_gray <= 3'b010;
                    3'b010: cnt_10_gray <= 3'b110;
                    3'b110: cnt_10_gray <= 3'b111;
                    default: cnt_10_gray <= 3'b000;
                endcase
            end
        end
    end

    // CLK_1 generation (divide by 100) with clock gating
    wire clk_1_enable = cnt_100_terminal;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 7'b111_1111; // Initialize to all 1's for down counter
        end else begin
            if (clk_1_enable) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 7'b111_1111; // Reset to all 1's
            end else begin
                cnt_100 <= cnt_100 - 1'b1;
            end
        end
    end

endmodule