module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // 32-bit counter (enough for >136 years at 1Hz)
    reg [31:0] counter;
    reg pm_reg;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            pm_reg <= 0;
        end else if (ena) begin
            if (counter == 43199) begin  // 11:59:59 PM
                counter <= 0;
                pm_reg <= ~pm_reg;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    // Time extraction
    wire [5:0] seconds = counter % 60;
    wire [5:0] minutes = (counter / 60) % 60;
    wire [4:0] hours = ((counter / 3600) % 12) + 1;  // 1-12

    // BCD conversion
    assign ss = {seconds[5:4], seconds[3:0]};
    assign mm = {minutes[5:4], minutes[3:0]};
    assign hh = (hours < 10) ? {4'b0, hours[3:0]} : {4'b0001, hours[3:0] - 4'd10};
    assign pm = pm_reg;

endmodule