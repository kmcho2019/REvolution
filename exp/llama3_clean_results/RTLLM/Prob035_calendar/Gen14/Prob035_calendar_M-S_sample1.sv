module calendar(
    input CLK, 
    input RST, 
    output reg [5:0] Secs, 
    output reg [5:0] Mins, 
    output reg [4:0] Hours
);

reg [31:0] seconds_counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        seconds_counter <= 32'b0;
    end else begin
        seconds_counter <= seconds_counter + 1'b1;
    end
end

always @(posedge CLK) begin
    Secs <= seconds_counter[5:0];
    Mins <= seconds_counter[11:6];
    Hours <= seconds_counter[17:12];
end

endmodule