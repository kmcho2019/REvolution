module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Next state values
wire [5:0] next_sec = (RST) ? 6'd0 : 
                     (Secs == 6'd59) ? 6'd0 : Secs + 6'd1;

wire sec_rollover = (Secs == 6'd59);
wire [5:0] next_min = (RST) ? 6'd0 : 
                     (sec_rollover) ? 
                     ((Mins == 6'd59) ? 6'd0 : Mins + 6'd1) : Mins;

wire min_rollover = (Mins == 6'd59) & sec_rollover;
wire [5:0] next_hour = (RST) ? 6'd0 : 
                      (min_rollover) ? 
                      ((Hours[4:0] == 5'd23) ? {1'b0, 5'd0} : {1'b0, Hours[4:0] + 5'd1}) : Hours;

// Sequential update
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