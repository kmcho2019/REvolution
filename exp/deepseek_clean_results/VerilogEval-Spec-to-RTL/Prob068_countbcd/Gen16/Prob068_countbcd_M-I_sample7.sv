module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg ena_tens, ena_hundreds, ena_thousands;
    
    assign q = {thousands, hundreds, tens, ones};
    assign ena = {ena_thousands, ena_hundreds, ena_tens};
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena_tens <= 1'b0;
            ena_hundreds <= 1'b0;
            ena_thousands <= 1'b0;
        end
        else begin
            // Ones digit always increments
            if (ones == 4'd9) begin
                ones <= 4'd0;
                ena_tens <= 1'b1;
            end
            else begin
                ones <= ones + 1;
                ena_tens <= 1'b0;
            end
            
            // Tens digit increments only when enabled
            if (ena_tens) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    ena_hundreds <= 1'b1;
                end
                else begin
                    tens <= tens + 1;
                    ena_hundreds <= 1'b0;
                end
            end
            else begin
                ena_hundreds <= 1'b0;
            end
            
            // Hundreds digit increments only when enabled
            if (ena_hundreds) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                    ena_thousands <= 1'b1;
                end
                else begin
                    hundreds <= hundreds + 1;
                    ena_thousands <= 1'b0;
                end
            end
            else begin
                ena_thousands <= 1'b0;
            end
            
            // Thousands digit increments only when enabled
            if (ena_thousands) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end
                else begin
                    thousands <= thousands + 1;
                end
            end
        end
    end

endmodule