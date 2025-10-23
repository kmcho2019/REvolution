module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Rollover conditions
wire sec_max = (Secs == 6'd59);
wire min_max = (Mins == 6'd59);
wire hour_max = (Hours[4:0] == 5'd23);

// Next value calculations (combinational)
wire [5:0] next_sec = sec_max ? 6'd0 : Secs + 6'd1;
wire [5:0] next_min = (sec_max && min_max) ? 6'd0 : 
                     (sec_max) ? Mins + 6'd1 : Mins;
wire [4:0] next_hour = (sec_max && min_max && hour_max) ? 5'd0 :
                      (sec_max && min_max) ? Hours[4:0] + 5'd1 : Hours[4:0];

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        Secs <= next_sec;
        Mins <= next_min;
        Hours <= {1'b0, next_hour};  // Zero-extend to 6 bits
    end
end

endmodule