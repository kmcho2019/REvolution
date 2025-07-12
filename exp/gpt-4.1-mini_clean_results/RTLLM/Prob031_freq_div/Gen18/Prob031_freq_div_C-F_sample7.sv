module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [2:0] cnt_10;    // Counter for divide by 10 (toggle every 5 cycles)
    reg [5:0] cnt_100;   // Counter for divide by 100 (toggle every 50 cycles)

    // Divide by 2 clock generation (50 MHz)
    // Separate always block for simplicity and minimal logic delay
    always @(posedge CLK_in) begin
        if (RST)
            CLK_50 <= 1'b0;
        else
            CLK_50 <= ~CLK_50;
    end

    // Combined logic for divide by 10 (10 MHz) and divide by 100 (1 MHz)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 3'd0;
            CLK_1  <= 1'b0;
            cnt_100 <= 6'd0;
        end else begin
            // 10 MHz clock logic: toggle every 5 cycles
            if (cnt_10 == 3'd4) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // 1 MHz clock logic: toggle every 50 cycles
            if (cnt_100 == 6'd49) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule