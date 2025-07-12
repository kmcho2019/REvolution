module calendar(
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

reg [19:0] counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        counter <= 20'd0;
    end else begin
        counter <= counter + 1'd1;
    end
end

always @(*) begin
    Secs = counter % 60;
    Mins = (counter / 60) % 60;
    Hours = (counter / 3600) % 24;
end

endmodule