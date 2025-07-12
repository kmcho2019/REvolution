module calendar(
    input CLK, 
    input RST, 
    output reg [5:0] Secs, 
    output reg [5:0] Mins, 
    output reg [4:0] Hours
);

reg [31:0] counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        counter <= 32'd0;
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        counter <= counter + 1;
        Secs <= counter[5:0];
        Mins <= (counter[11:6] == 6'd59)? (counter[17:12] == 6'd59)? (counter[18] == 1'b1)? 6'd0 : 6'd0 : counter[11:6] : (counter[5:0] == 6'd59)? (counter[11:6] + 1) : counter[11:6];
        Hours <= (counter[17:12] == 6'd59 && counter[11:6] == 6'd59 && counter[5:0] == 6'd59)? (counter[18] == 1'b1)? 5'd0 : 5'd0 : (counter[11:6] == 6'd59 && counter[5:0] == 6'd59)? (counter[17:12] + 1) : counter[17:12];
    end
end

endmodule