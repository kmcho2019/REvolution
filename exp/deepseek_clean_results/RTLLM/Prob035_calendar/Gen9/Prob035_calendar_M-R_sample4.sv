module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Next value calculations
wire [5:0] next_sec = (Secs == 6'd59) ? 6'd0 : (Secs + 6'd1);
wire sec_rollover = (Secs == 6'd59);

wire [5:0] next_min = (Mins == 6'd59 && sec_rollover) ? 6'd0 : 
                     (sec_rollover ? (Mins + 6'd1) : Mins);
wire min_rollover = (Mins == 6'd59) && sec_rollover;

wire [4:0] next_hour = (Hours == 5'd23 && min_rollover) ? 5'd0 :
                      (min_rollover ? (Hours + 5'd1) : Hours);

// Sequential update block
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        Secs <= next_sec;
        Mins <= next_min;
        Hours <= next_hour;
    end
end

endmodule