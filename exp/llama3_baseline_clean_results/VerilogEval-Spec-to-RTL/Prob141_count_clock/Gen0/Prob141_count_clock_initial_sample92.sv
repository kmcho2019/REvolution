module TopModule(
    input  clk,
    input  reset,
    input  ena,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss,
    output reg pm
);

reg [7:0] sec;
reg [7:0] min;
reg [7:0] hour;

always @(posedge clk) begin
    if (reset) begin
        sec <= 8'b00000000;  // Initialize seconds to 00
        min <= 8'b00000000;  // Initialize minutes to 00
        hour <= 8'b00010010;  // Initialize hours to 12
        pm <= 1'b0;           // Initialize to AM
    end else if (ena) begin
        if (sec == 8'b00111011) begin  // 59 in BCD
            sec <= 8'b00000000;  // Reset seconds to 00
            if (min == 8'b00111011) begin  // 59 in BCD
                min <= 8'b00000000;  // Reset minutes to 00
                if (hour == 8'b00010010) begin  // 12 in BCD
                    hour <= 8'b00010001;  // Set hours to 01
                    pm <= ~pm;             // Toggle AM/PM
                end else if (hour == 8'b00010100) begin  // 12 in BCD for PM
                    hour <= 8'b00010001;  // Set hours to 01
                    pm <= ~pm;             // Toggle AM/PM
                end else begin
                    hour <= hour + 1;      // Increment hours
                end
            end else begin
                min <= min + 1;            // Increment minutes
            end
        end else begin
            sec <= sec + 1;                // Increment seconds
        end
    end
end

assign hh = hour;
assign mm = min;
assign ss = sec;

endmodule