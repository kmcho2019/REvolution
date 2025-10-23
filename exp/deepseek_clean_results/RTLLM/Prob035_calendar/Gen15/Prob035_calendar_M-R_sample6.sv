module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 0-23 (5 bits)
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SEC = 6'd59;
localparam MAX_MIN = 6'd59;
localparam MAX_HOUR = 5'd23;

// Next state values (combinational logic)
wire [5:0] next_sec = (RST) ? 6'd0 : 
                     (Secs == MAX_SEC) ? 6'd0 : Secs + 6'd1;

wire [5:0] next_min = (RST) ? 6'd0 : 
                     ((Secs == MAX_SEC) ? 
                        ((Mins == MAX_MIN) ? 6'd0 : Mins + 6'd1) 
                     : Mins);

wire [4:0] next_hour = (RST) ? 5'd0 : 
                      ((Secs == MAX_SEC && Mins == MAX_MIN) ? 
                         ((Hours == MAX_HOUR) ? 5'd0 : Hours + 5'd1) 
                      : Hours);

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