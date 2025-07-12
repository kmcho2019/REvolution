module calendar(
    input CLK, 
    input RST, 
    output reg [5:0] Secs, 
    output reg [5:0] Mins, 
    output reg [4:0] Hours
);

reg [25:0] counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        counter <= 26'b0;
    end else begin
        counter <= counter + 1'b1;
    end
end

always @(posedge CLK) begin
    Secs <= counter[5:0];
    Mins <= counter[11:6];
    Hours <= counter[16:11];
end

endmodule