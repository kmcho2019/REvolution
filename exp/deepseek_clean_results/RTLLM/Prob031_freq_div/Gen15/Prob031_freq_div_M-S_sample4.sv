module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // 10MHz counter (divide by 10)
    reg [2:0] cnt10;  // counts 0-4 (5 cycles per half period)

    // 1MHz counter (divide by 100)
    reg [6:0] cnt100; // counts 0-49 (50 cycles per half period)

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
            cnt10 <= 0;
        end else begin
            if (cnt10 == 4) begin
                CLK_10 <= ~CLK_10;
                cnt10 <= 0;
            end else begin
                cnt10 <= cnt10 + 1'b1;
            end
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt100 <= 0;
        end else begin
            if (cnt100 == 49) begin
                CLK_1 <= ~CLK_1;
                cnt100 <= 0;
            end else begin
                cnt100 <= cnt100 + 1'b1;
            end
        end
    end

endmodule