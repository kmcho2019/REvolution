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
wire [5:0] next_sec = (RST) ? 6'd0 : 
                     (Secs == MAX_SEC_MIN) ? 6'd0 : Secs + 1;

wire sec_rollover = (Secs == MAX_SEC_MIN);
wire [5:0] next_min = (RST) ? 6'd0 : 
                     (sec_rollover) ? 
                         ((Mins == MAX_SEC_MIN) ? 6'd0 : Mins + 1) : 
                         Mins;

wire min_rollover = (Mins == MAX_SEC_MIN) & sec_rollover;
wire [5:0] next_hour = (RST) ? 6'd0 : 
                      (min_rollover) ? 
                          ((Hours == MAX_HOUR) ? 6'd0 : Hours + 1) : 
                          Hours;

// Single synchronous update block
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