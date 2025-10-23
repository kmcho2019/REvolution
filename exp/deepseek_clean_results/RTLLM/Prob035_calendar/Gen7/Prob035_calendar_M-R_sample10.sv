module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 5 bits for 0-23
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Next state values
wire [5:0] next_sec = (Secs == 6'd59) ? 6'd0 : (Secs + 6'd1);
wire sec_rollover = (Secs == 6'd59);

wire [5:0] next_min = (sec_rollover && (Mins == 6'd59)) ? 6'd0 : 
                     (sec_rollover) ? (Mins + 6'd1) : Mins;
wire min_rollover = (sec_rollover && (Mins == 6'd59));

wire [4:0] next_hour = (min_rollover && (Hours == 5'd23)) ? 5'd0 : 
                      (min_rollover) ? (Hours + 5'd1) : Hours;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset all counters
        Hours <= 5'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        // Update registers with next state values
        Secs <= next_sec;
        Mins <= next_min;
        Hours <= next_hour;
    end
end

endmodule