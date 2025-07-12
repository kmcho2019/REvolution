module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [31:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
    end else if (ena) begin
        counter <= counter + 1;
    end
end

// Calculate hours, minutes, and seconds from the counter value
reg [4:0] hours_temp;
reg [5:0] minutes_temp;
reg [5:0] seconds_temp;

always @(posedge clk) begin
    hours_temp <= (counter / 3600) % 12;
    minutes_temp <= (counter / 60) % 60;
    seconds_temp <= counter % 60;
    
    if (reset) begin
        pm <= 0;
        hh <= 8'h12; // Initial hours (12)
        mm <= 8'h00; // Initial minutes (00)
        ss <= 8'h00; // Initial seconds (00)
    end else begin
        // Convert hours, minutes, and seconds to BCD
        hh <= {4'b0000, hours_temp};
        mm <= {2'b00, minutes_temp};
        ss <= {2'b00, seconds_temp};
        
        // Determine AM/PM flag
        if (hours_temp == 0) begin
            pm <= 0; // AM
        end else if (hours_temp >= 6 && hours_temp < 12) begin
            pm <= 1; // PM
        end else if (hours_temp == 12) begin
            pm <= 1; // PM
        end else begin
            pm <= 0; // AM
        end
    end
end

endmodule