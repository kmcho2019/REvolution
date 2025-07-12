module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Gray code counter for 10MHz clock (divide by 10)
    reg [2:0] cnt_10_gray;
    wire [2:0] cnt_10_bin;
    
    // Down counter for 1MHz clock (divide by 100)
    reg [6:0] cnt_100_down;
    wire cnt_100_done = (cnt_100_down == 7'd0);

    // Gray to binary conversion for cnt_10
    assign cnt_10_bin = {cnt_10_gray[2],
                        cnt_10_gray[2] ^ cnt_10_gray[1],
                        cnt_10_gray[2] ^ cnt_10_gray[1] ^ cnt_10_gray[0]};

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end
        else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10_gray <= 3'b0;
        end
        else begin
            if (cnt_10_bin == 3'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10_gray <= 3'b0;
            end
            else begin
                // Gray code increment
                case (cnt_10_gray)
                    3'b000: cnt_10_gray <= 3'b001;
                    3'b001: cnt_10_gray <= 3'b011;
                    3'b011: cnt_10_gray <= 3'b010;
                    3'b010: cnt_10_gray <= 3'b110;
                    3'b110: cnt_10_gray <= 3'b111;
                    3'b111: cnt_10_gray <= 3'b101;
                    3'b101: cnt_10_gray <= 3'b100;
                    3'b100: cnt_10_gray <= 3'b000;
                    default: cnt_10_gray <= 3'b000;
                endcase
            end
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100_down <= 7'd99;
        end
        else begin
            if (cnt_100_done) begin
                CLK_1 <= ~CLK_1;
                cnt_100_down <= 7'd99;
            end
            else begin
                cnt_100_down <= cnt_100_down - 1'b1;
            end
        end
    end

endmodule