module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 0-23 (5 bits)
    output reg [5:0] Mins,   // 0-59 (6 bits)
    output reg [5:0] Secs    // 0-59 (6 bits)
);

// Next state values
wire [5:0] next_sec = (RST) ? 6'd0 : 
                     (Secs == 6'd59) ? 6'd0 : Secs + 6'd1;

wire [5:0] next_min = (RST) ? 6'd0 : 
                     (Secs == 6'd59) ? 
                        ((Mins == 6'd59) ? 6'd0 : Mins + 6'd1) : 
                     Mins;

wire [4:0] next_hour = (RST) ? 5'd0 : 
                      ((Secs == 6'd59) && (Mins == 6'd59)) ? 
                         ((Hours == 5'd23) ? 5'd0 : Hours + 5'd1) : 
                      Hours;

always @(posedge CLK or posedge RST) begin
    Secs <= next_sec;
    Mins <= next_min;
    Hours <= next_hour;
end

endmodule