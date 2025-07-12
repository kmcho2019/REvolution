module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SEC_MIN = 6'd59;
localparam MAX_HOUR = 6'd23;

// Next value calculations
wire [5:0] next_sec = (Secs == MAX_SEC_MIN) ? 6'd0 : (Secs + 1);
wire [5:0] next_min = (Mins == MAX_SEC_MIN && Secs == MAX_SEC_MIN) ? 6'd0 : 
                     (Secs == MAX_SEC_MIN) ? (Mins + 1) : Mins;
wire [5:0] next_hour = (Hours == MAX_HOUR && Mins == MAX_SEC_MIN && Secs == MAX_SEC_MIN) ? 6'd0 :
                       (Mins == MAX_SEC_MIN && Secs == MAX_SEC_MIN) ? (Hours + 1) : Hours;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Update all counters in one clock cycle
        Secs <= next_sec;
        Mins <= next_min;
        Hours <= next_hour;
    end
end

endmodule