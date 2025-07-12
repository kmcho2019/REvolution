module calendar(
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

reg [16:0] counter; // 17-bit counter to cover up to 131071 clock cycles

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        counter <= 17'd0;
    end else begin
        counter <= counter + 1'b1;
        if (counter == 17'd86400) begin // reset counter after 86400 seconds (1 day)
            counter <= 17'd0;
        end
    end
end

always @(*) begin
    Secs = counter[5:0]; // extract seconds (0-59)
    Mins = counter[11:6]; // extract minutes (0-59)
    Hours = counter[16:12]; // extract hours (0-23)
end

endmodule