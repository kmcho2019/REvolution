module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Counters
    reg [1:0] cnt2 = 0;    // for 50MHz (divide by 2)
    reg [3:0] cnt10 = 0;   // for 10MHz (divide by 10)
    reg [6:0] cnt100 = 0;  // for 1MHz (divide by 100)

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 0;
            cnt10 <= 0;
        end else if (cnt10 == 4) begin
            CLK_10 <= ~CLK_10;
            cnt10 <= 0;
        end else begin
            cnt10 <= cnt10 + 1;
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 0;
            cnt100 <= 0;
        end else if (cnt100 == 49) begin
            CLK_1 <= ~CLK_1;
            cnt100 <= 0;
        end else begin
            cnt100 <= cnt100 + 1;
        end
    end

endmodule