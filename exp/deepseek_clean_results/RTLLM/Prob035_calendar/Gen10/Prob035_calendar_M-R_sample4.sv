module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 0-23 (5 bits)
    output reg [5:0] Mins,   // 0-59 (6 bits)
    output reg [5:0] Secs    // 0-59 (6 bits)
);

// Constants
localparam MAX_SEC = 6'd59;
localparam MAX_MIN = 6'd59;
localparam MAX_HOUR = 5'd23;

// Next state values
wire [5:0] next_sec;
wire [5:0] next_min;
wire [4:0] next_hour;

// Rollover conditions
wire sec_max = (Secs == MAX_SEC);
wire min_max = (Mins == MAX_MIN);
wire hour_max = (Hours == MAX_HOUR);

// Continuous assignments for next state logic
assign next_sec = RST ? 6'd0 : 
                 (sec_max ? 6'd0 : Secs + 6'd1);

assign next_min = RST ? 6'd0 : 
                 (sec_max ? (min_max ? 6'd0 : Mins + 6'd1) : Mins);

assign next_hour = RST ? 5'd0 : 
                  (sec_max & min_max) ? 
                      (hour_max ? 5'd0 : Hours + 5'd1) : Hours);

// Single always block for sequential elements
always @(posedge CLK) begin
    Secs <= next_sec;
    Mins <= next_min;
    Hours <= next_hour;
end

endmodule