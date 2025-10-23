module calendar(
    input CLK, 
    input RST, 
    output reg [5:0] Secs, 
    output reg [5:0] Mins, 
    output reg [4:0] Hours
);

wire [5:0] next_Secs;
wire [5:0] next_Mins;
wire [4:0] next_Hours;

assign next_Secs = (RST || Secs == 6'd59) ? 6'b0 : (Secs + 1'b1);
assign next_Mins = (RST || (Mins == 6'd59 && Secs == 6'd59)) ? 6'b0 : (Mins + ((Secs == 6'd59) ? 1'b1 : 1'b0));
assign next_Hours = (RST || (Hours == 5'd23 && Mins == 6'd59 && Secs == 6'd59)) ? 5'b0 : (Hours + ((Mins == 6'd59 && Secs == 6'd59) ? 1'b1 : 1'b0));

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'b0;
        Mins <= 6'b0;
        Hours <= 5'b0;
    end else begin
        Secs <= next_Secs;
        Mins <= next_Mins;
        Hours <= next_Hours;
    end
end

endmodule