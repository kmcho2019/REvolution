module calendar(
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

reg [19:0] time_counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        time_counter <= 20'd0;
    end else begin
        time_counter <= time_counter + 1'd1;
    end
end

always @(*) begin
    Secs = time_counter[5:0]; // Lower 6 bits for seconds
    Mins = time_counter[11:6]; // Next 6 bits for minutes
    if (time_counter[19:12] > 5'd23) begin // Upper 8 bits for hours with wrap-around
        Hours = 5'd0;
    end else begin
        Hours = time_counter[19:15]; // Extract hours
    end
end

endmodule