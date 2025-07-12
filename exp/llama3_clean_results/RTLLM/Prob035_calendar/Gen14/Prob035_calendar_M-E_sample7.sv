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
        counter <= 32'b0;
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