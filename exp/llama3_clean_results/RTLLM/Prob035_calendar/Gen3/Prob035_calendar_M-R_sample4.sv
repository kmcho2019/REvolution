module calendar(
    input CLK, 
    input RST, 
    output reg [5:0] Secs, 
    output reg [5:0] Mins, 
    output reg [4:0] Hours
);

reg [17:0] time;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        time <= 18'b0;
    end else begin
        time <= time + 1'b1;
        if (time == 18'd59_59_59) begin
            time <= 18'b0;
        end
    end
end

assign Secs = time[5:0];
assign Mins = time[11:6];
assign Hours = time[16:12];

endmodule