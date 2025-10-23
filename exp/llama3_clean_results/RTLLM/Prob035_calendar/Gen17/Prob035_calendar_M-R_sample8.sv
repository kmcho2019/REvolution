module calendar #(
    parameter CLK_FREQ = 1000000, // clock frequency in Hz
    parameter SEC_WIDTH = 6,
    parameter MIN_WIDTH = 6,
    parameter HOUR_WIDTH = 5
)(
    input CLK,
    input RST,
    output reg [SEC_WIDTH-1:0] Secs,
    output reg [MIN_WIDTH-1:0] Mins,
    output reg [HOUR_WIDTH-1:0] Hours
);

reg [31:0] counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        counter <= 32'd0;
    end else begin
        counter <= counter + 32'd1;
    end
end

assign Secs = counter % 60;
assign Mins = (counter / 60) % 60;
assign Hours = (counter / 3600) % 24;

endmodule