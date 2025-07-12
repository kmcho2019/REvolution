module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Counter for dividing 50 MHz clock by 5 to get 10 MHz
    reg [2:0] cnt_10_div;
    // Counter for dividing 10 MHz clock by 10 to get 1 MHz
    reg [3:0] cnt_1_div;

    // Generate 50 MHz clock by toggling every CLK_in cycle (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Generate 10 MHz clock by dividing CLK_50 by 5
    always @(posedge CLK_50 or posedge RST) begin
        if (RST) begin
            cnt_10_div <= 3'd0;
            CLK_10 <= 1'b0;
        end else begin
            if (cnt_10_div == 3'd4) begin
                cnt_10_div <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10_div <= cnt_10_div + 1'b1;
            end
        end
    end

    // Generate 1 MHz clock by dividing CLK_10 by 10
    always @(posedge CLK_10 or posedge RST) begin
        if (RST) begin
            cnt_1_div <= 4'd0;
            CLK_1 <= 1'b0;
        end else begin
            if (cnt_1_div == 4'd9) begin
                cnt_1_div <= 4'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_1_div <= cnt_1_div + 1'b1;
            end
        end
    end

endmodule