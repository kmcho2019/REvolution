module calendar (
    input CLK,
    input RST,
    output wire [5:0] Hours,
    output wire [5:0] Mins,
    output wire [5:0] Secs
);

reg [31:0] total_seconds;

// Total seconds counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        total_seconds <= 32'd0;
    end else begin
        total_seconds <= total_seconds + 32'd1;
    end
end

// Continuous time decoding
assign Secs = total_seconds % 60;
assign Mins = (total_seconds / 60) % 60;
assign Hours = (total_seconds / 3600) % 24;

endmodule