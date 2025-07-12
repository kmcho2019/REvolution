module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [5:0] cnt_shared;  // Shared counter for CLK_10 and CLK_1

    // CLK_50: divide by 2 (toggle every clock)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Shared counter for CLK_10 and CLK_1
    // CLK_10 toggles at count 4, 9, 14... (every 5 cycles)
    // CLK_1 toggles at count 49 (every 50 cycles)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_shared <= 6'd0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            if (cnt_shared == 6'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_shared <= 6'd0;
            end else begin
                cnt_shared <= cnt_shared + 1'b1;
            end

            // Toggle CLK_10 when cnt_shared modulo 5 equals 4
            if ((cnt_shared % 5) == 6'd4) begin
                CLK_10 <= ~CLK_10;
            end
        end
    end

endmodule