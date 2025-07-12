module calendar(
    input           CLK,    // Clock input
    input           RST,    // Active high reset signal
    output reg [5:0] Hours, // 6-bit output representing the current hours
    output reg [5:0] Mins,  // 6-bit output representing the current minutes
    output reg [5:0] Secs   // 6-bit output representing the current seconds
);

reg [23:0] counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        counter <= 24'd0;
    end else begin
        counter <= counter + 1;
    end
end

always @(*) begin
    if (counter < 24'd60) begin
        Hours <= 6'd0;
        Mins <= 6'd0;
        Secs <= counter[5:0];
    end else if (counter < 24'd3600) begin
        Hours <= 6'd0;
        Mins <= counter[11:6];
        Secs <= counter[5:0];
    end else begin
        Hours <= counter[17:12];
        Mins <= counter[11:6];
        Secs <= counter[5:0];
    end
end

endmodule