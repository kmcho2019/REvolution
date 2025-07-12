module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

reg [31:0] counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        counter <= 32'd0;
    end else begin
        counter <= counter + 32'd1;
    end
end

always @(*) begin
    Secs = counter[5:0];
    Mins = (counter[11:6]) % 60;
    Hours = (counter[17:12]) % 24;
end

endmodule