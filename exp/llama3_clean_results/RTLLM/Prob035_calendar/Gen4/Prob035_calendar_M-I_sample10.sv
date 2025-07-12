module calendar(
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

reg [10:0] counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        counter <= 11'd0;
    end else begin
        counter <= counter + 11'd1;
        Secs <= counter[5:0];
        Mins <= counter[11:6];
        Hours <= counter[10:6];
    end
end

endmodule