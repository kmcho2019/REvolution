module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Combinational rollover and enable logic
wire sec_max = (Secs == 6'd59);
wire min_max = (Mins == 6'd59);
wire hour_max = (Hours[4:0] == 5'd23);

wire sec_en = 1'b1;  // Always enabled
wire min_en = sec_max;
wire hour_en = sec_max & min_max;

// Next state computation
wire [5:0] next_sec = sec_max ? 6'd0 : Secs + 6'd1;
wire [5:0] next_min = min_en ? (min_max ? 6'd0 : Mins + 6'd1) : Mins;
wire [5:0] next_hour = hour_en ? (hour_max ? 6'd0 : {1'b0, Hours[4:0] + 5'd1}) : Hours;

// Unified sequential update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        Secs <= next_sec;
        Mins <= next_min;
        Hours <= next_hour;
    end
end

endmodule