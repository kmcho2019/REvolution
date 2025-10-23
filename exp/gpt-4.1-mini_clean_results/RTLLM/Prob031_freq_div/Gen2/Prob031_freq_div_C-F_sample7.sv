module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Counter for dividing by 10 (to generate 10 MHz clock)
    // Counts from 0 to 4, toggling CLK_10 at count 4 to get 10 MHz from 100 MHz input
    reg [2:0] cnt_10;

    // Counter for dividing by 100 (to generate 1 MHz clock)
    // Counts from 0 to 49, toggling CLK_1 at count 49 to get 1 MHz from 100 MHz input
    reg [5:0] cnt_100;

    // Generate 50 MHz clock by toggling every CLK_in cycle (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Generate 10 MHz clock: toggle CLK_10 every 5 input clock cycles (count 0 to 4)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 3'd0;
        end else begin
            if (cnt_10 == 3'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                cnt_10 <= cnt_10 + 3'd1;
            end
        end
    end

    // Generate 1 MHz clock: toggle CLK_1 every 50 input clock cycles (count 0 to 49)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 6'd0;
        end else begin
            if (cnt_100 == 6'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end else begin
                cnt_100 <= cnt_100 + 6'd1;
            end
        end
    end

endmodule