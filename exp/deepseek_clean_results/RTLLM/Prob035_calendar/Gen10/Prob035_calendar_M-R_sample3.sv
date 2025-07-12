module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Combinational next-state logic
wire [5:0] next_sec = (Secs == 6'd59) ? 6'd0 : Secs + 6'd1;
wire sec_rollover = (Secs == 6'd59);

wire [5:0] next_min = sec_rollover ? 
                     ((Mins == 6'd59) ? 6'd0 : Mins + 6'd1) : 
                     Mins;
wire min_rollover = (Mins == 6'd59) & sec_rollover;

wire [4:0] next_hour = min_rollover ? 
                      ((Hours[4:0] == 5'd23) ? 5'd0 : Hours[4:0] + 5'd1 : 
                      Hours[4:0];

// Single sequential block for all state updates
always @(posedge CLK) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        Secs <= next_sec;
        Mins <= next_min;
        Hours <= {1'b0, next_hour}; // Zero-extend to 6 bits
    end
end

endmodule