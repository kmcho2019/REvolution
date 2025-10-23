module calendar(
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

reg [10:0] counter; // 11-bit counter to handle up to 60*60*24 - 1

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        counter <= 11'd0;
    end else begin
        counter <= counter + 1'd1;
        if (counter == 11'd86399) begin // 24*60*60 - 1
            counter <= 11'd0;
        end
    end
end

always @(*) begin
    Secs = counter[5:0]; // Lower 6 bits for seconds
    Mins = counter[10:6] == 6'd0 ? 6'd0 : (counter[10:6] - 6'd1); // Upper 6 bits for minutes, adjust for 0-59 range
    Hours = counter[10:6] == 6'd0 ? 5'd0 : (counter[10:6] - 6'd1) / 6'd60; // Extract hours
end

endmodule