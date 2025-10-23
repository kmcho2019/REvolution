module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 5'd23;

// Next state values
wire [5:0] next_sec = (Secs == SEC_MAX) ? 6'd0 : Secs + 1;
wire [5:0] next_min = (Secs == SEC_MAX) ? 
                     ((Mins == MIN_MAX) ? 6'd0 : Mins + 1) : Mins;
wire [4:0] next_hour = (Secs == SEC_MAX && Mins == MIN_MAX) ?
                      ((Hours == HOUR_MAX) ? 5'd0 : Hours + 1) : Hours;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        Secs <= next_sec;
        Mins <= next_min;
        Hours <= next_hour;
    end
end

endmodule