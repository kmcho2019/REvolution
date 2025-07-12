module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Next-state wires
wire [5:0] next_sec;
wire [5:0] next_min;
wire [5:0] next_hour;

// Rollover conditions
wire sec_max = (Secs == 6'd59);
wire min_max = (Mins == 6'd59);
wire hour_max = (Hours == 6'd23);

// Next state calculations (combinational)
assign next_sec = RST ? 6'd0 : 
                 (sec_max ? 6'd0 : Secs + 6'd1);

assign next_min = RST ? 6'd0 : 
                 (sec_max ? (min_max ? 6'd0 : Mins + 6'd1) : Mins);

assign next_hour = RST ? 6'd0 : 
                  ((sec_max & min_max) ? 
                   (hour_max ? 6'd0 : Hours + 6'd1) : Hours);

// Sequential state update
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