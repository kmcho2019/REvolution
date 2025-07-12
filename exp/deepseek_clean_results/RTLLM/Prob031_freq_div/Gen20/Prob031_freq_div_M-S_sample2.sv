module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Counters
    reg [2:0] cnt_10;  // Needs to count to 4 (3 bits)
    reg [6:0] cnt_100; // Needs to count to 49 (7 bits)

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
            cnt_10 <= 3'b0;
        end else if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'b0;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 7'b0;
        end else if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 7'b0;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end

endmodule