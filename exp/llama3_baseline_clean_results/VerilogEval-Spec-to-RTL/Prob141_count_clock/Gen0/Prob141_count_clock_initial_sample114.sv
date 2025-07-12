module TopModule(
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [31:0] second_counter;

always @(posedge clk) begin
    if (reset) begin
        pm <= 0;
        hh <= 8'h12;
        mm <= 8'h00;
        ss <= 8'h00;
        second_counter <= 0;
    end
    else if (ena) begin
        second_counter <= second_counter + 1;
        
        if (second_counter == 100000000) begin
            second_counter <= 0;
            if (ss == 8'h59) begin
                ss <= 8'h00;
                if (mm == 8'h59) begin
                    mm <= 8'h00;
                    if (hh == 8'h12) begin
                        hh <= 8'h01;
                        pm <= ~pm;
                    end
                    else if (hh == 8'h01 && pm == 0) begin
                        hh <= 8'h02;
                    end
                    else if (hh == 8'h12 && pm == 0) begin
                        hh <= 8'h01;
                        pm <= ~pm;
                    end
                    else if (hh == 8'h12 && pm == 1) begin
                        hh <= 8'h01;
                    end
                    else begin
                        hh <= hh + 1;
                    end
                end
                else begin
                    mm <= mm + 1;
                end
            end
            else begin
                ss <= ss + 1;
            end
        end
    end
end

endmodule