module calendar (
    input CLK,
    input RST,
    output [5:0] Hours,
    output [5:0] Mins,
    output [5:0] Secs
);

// Internal registers (minimum required width)
reg [5:0] sec_reg;
reg [5:0] min_reg;
reg [4:0] hour_reg;  // Only needs 5 bits for 0-23

// Continuous assignments for outputs
assign Secs = sec_reg;
assign Mins = min_reg;
assign Hours = {1'b0, hour_reg};  // Zero-extend to 6 bits

// Rollover detection
wire sec_max = (sec_reg == 6'd59);
wire min_max = (min_reg == 6'd59);
wire hour_max = (hour_reg == 5'd23);

// Next-state logic
wire [5:0] next_sec = RST ? 6'd0 : (sec_max ? 6'd0 : sec_reg + 6'd1);
wire [5:0] next_min = RST ? 6'd0 : 
                     (sec_max ? (min_max ? 6'd0 : min_reg + 6'd1) : min_reg);
wire [4:0] next_hour = RST ? 5'd0 : 
                      (sec_max && min_max) ? 
                      (hour_max ? 5'd0 : hour_reg + 5'd1) : hour_reg;

// Sequential update
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

endmodule