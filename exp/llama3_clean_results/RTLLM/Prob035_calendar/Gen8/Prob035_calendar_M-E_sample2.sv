module calendar(
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

reg [31:0] total_seconds;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        total_seconds <= 32'd0;
    end else begin
        total_seconds <= total_seconds + 32'd1;
    end
end

always @(*) begin
    Secs = total_seconds % 60;
    Mins = (total_seconds / 60) % 60;
    Hours = (total_seconds / 3600) % 24;
end

endmodule