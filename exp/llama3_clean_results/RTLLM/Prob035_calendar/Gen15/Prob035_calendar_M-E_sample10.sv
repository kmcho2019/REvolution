module calendar(
    input CLK, 
    input RST, 
    output reg [4:0] Hours, 
    output reg [5:0] Mins, 
    output reg [5:0] Secs
);

reg [21:0] counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        counter <= 22'b0;
    end else begin
        counter <= counter + 1'b1;
    end
end

always @(*) begin
    Secs = counter[5:0];
    Mins = counter[11:6];
    Hours = counter[17:12];
end

endmodule