module calendar (
    input CLK,
    input RST,
    output [5:0] Hours,
    output [5:0] Mins,
    output [5:0] Secs
);

reg [5:0] sec_reg, min_reg;
reg [4:0] hour_reg;  // Only need 5 bits for 0-23

// Next state logic
wire [5:0] next_sec = (sec_reg == 6'd59) ? 6'd0 : sec_reg + 6'd1;
wire sec_rollover = (sec_reg == 6'd59);

wire [5:0] next_min = (min_reg == 6'd59) && sec_rollover ? 6'd0 : 
                     sec_rollover ? min_reg + 6'd1 : min_reg;
wire min_rollover = (min_reg == 6'd59) && sec_rollover;

wire [4:0] next_hour = (hour_reg == 5'd23) && min_rollover ? 5'd0 :
                      min_rollover ? hour_reg + 5'd1 : hour_reg;

// Sequential updates
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        sec_reg <= 6'd0;
        min_reg <= 6'd0;
        hour_reg <= 5'd0;
    end else begin
        sec_reg <= next_sec;
        min_reg <= next_min;
        hour_reg <= next_hour;
    end
end

// Output assignments with zero-extension for hours
assign Secs = sec_reg;
assign Mins = min_reg;
assign Hours = {1'b0, hour_reg};  // Zero-extend to 6 bits

endmodule