module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

wire [5:0] next_sec = (Secs == 6'd59) ? 6'd0 : Secs + 1;
wire [5:0] next_min = (Mins == 6'd59 && Secs == 6'd59) ? 6'd0 : 
                     (Secs == 6'd59) ? Mins + 1 : Mins;
wire [4:0] next_hr = (Hours[4:0] == 5'd23 && Mins == 6'd59 && Secs == 6'd59) ? 5'd0 :
                    (Mins == 6'd59 && Secs == 6'd59) ? Hours[4:0] + 1 : Hours[4:0];

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        Secs <= next_sec;
        Mins <= next_min;
        Hours <= {1'b0, next_hr};  // Zero-extend to 6 bits
    end
end

endmodule