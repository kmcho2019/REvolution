module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Internal signals
    reg [1:0] cnt_5;   // Counter for divide by 5 (2 bits)
    reg [3:0] cnt_10;  // Counter for divide by 10 (4 bits)

    // Stage 1: Generate 50MHz (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Stage 2: Generate 10MHz (divide 50MHz by 5)
    always @(posedge CLK_50 or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_5 <= 2'b0;
        end else begin
            if (cnt_5 == 2'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_5 <= 2'b0;
            end else begin
                cnt_5 <= cnt_5 + 2'b1;
            end
        end
    end

    // Stage 3: Generate 1MHz (divide 10MHz by 10)
    always @(posedge CLK_10 or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_10 <= 4'b0;
        end else begin
            if (cnt_10 == 4'd9) begin
                CLK_1 <= ~CLK_1;
                cnt_10 <= 4'b0;
            end else begin
                cnt_10 <= cnt_10 + 4'b1;
            end
        end
    end

endmodule