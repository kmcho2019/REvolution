module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 5 bits for 0-23
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Next value calculations
wire [5:0] next_sec = (RST) ? 6'd0 : 
                     (Secs == 6'd59) ? 6'd0 : Secs + 6'd1;

wire [5:0] next_min = (RST) ? 6'd0 : 
                     ((Secs == 6'd59) && (Mins == 6'd59)) ? 6'd0 :
                     (Secs == 6'd59) ? Mins + 6'd1 : Mins;

wire [4:0] next_hour = (RST) ? 5'd0 :
                      ((Secs == 6'd59) && (Mins == 6'd59) && (Hours == 5'd23)) ? 5'd0 :
                      ((Secs == 6'd59) && (Mins == 6'd59)) ? Hours + 5'd1 : Hours;

always @(posedge CLK) begin
    Secs <= next_sec;
    Mins <= next_min;
    Hours <= next_hour;
end

endmodule