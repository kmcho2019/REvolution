module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    reg [6:0] cnt_main;  // count 0 to 99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_main <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else begin
            if (cnt_main == 7'd99) begin
                cnt_main <= 7'd0;
            end else begin
                cnt_main <= cnt_main + 7'd1;
            end

            // CLK_50 toggles every clock cycle (divide by 2)
            // Since we have a main counter, toggle CLK_50 every time counter is even (or at cnt_main == 0)
            // To keep a 50% duty cycle, toggle on every clock
            CLK_50 <= ~CLK_50;

            // CLK_10 toggles every 5 cycles (half period)
            if (cnt_main == 7'd4 || cnt_main == 7'd9 || cnt_main == 7'd14 || cnt_main == 7'd19 ||
                cnt_main == 7'd24 || cnt_main == 7'd29 || cnt_main == 7'd34 || cnt_main == 7'd39 ||
                cnt_main == 7'd44 || cnt_main == 7'd49 || cnt_main == 7'd54 || cnt_main == 7'd59 ||
                cnt_main == 7'd64 || cnt_main == 7'd69 || cnt_main == 7'd74 || cnt_main == 7'd79 ||
                cnt_main == 7'd84 || cnt_main == 7'd89 || cnt_main == 7'd94 || cnt_main == 7'd99) begin
                CLK_10 <= ~CLK_10;
            end

            // CLK_1 toggles every 50 cycles (half period)
            if (cnt_main == 7'd49 || cnt_main == 7'd99) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule