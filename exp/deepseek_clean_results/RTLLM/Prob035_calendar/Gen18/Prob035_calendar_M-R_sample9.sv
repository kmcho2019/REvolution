module calendar (
    input CLK,
    input RST,
    output [5:0] Hours,
    output [5:0] Mins,
    output [5:0] Secs
);

reg [5:0] next_sec, next_min;
reg [4:0] next_hour;  // Only need 5 bits for 0-23
reg [5:0] sec_reg, min_reg;
reg [4:0] hour_reg;

// Combinational next-state logic
assign next_sec = RST ? 6'd0 : 
                 (sec_reg == 6'd59) ? 6'd0 : sec_reg + 6'd1;

assign next_min = RST ? 6'd0 : 
                 (sec_reg == 6'd59) ? 
                    (min_reg == 6'd59) ? 6'd0 : min_reg + 6'd1 
                 : min_reg;

assign next_hour = RST ? 5'd0 : 
                  ((sec_reg == 6'd59) && (min_reg == 6'd59)) ? 
                      (hour_reg == 5'd23) ? 5'd0 : hour_reg + 5'd1 
                  : hour_reg;

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

// Output assignments
assign Secs = sec_reg;
assign Mins = min_reg;
assign Hours = {1'b0, hour_reg};  // Zero-extend to 6 bits

endmodule