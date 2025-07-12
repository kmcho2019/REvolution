module calendar (
    input CLK,
    input RST,
    output [5:0] Hours,
    output [5:0] Mins,
    output [5:0] Secs
);

// Current state registers
reg [5:0] curr_sec;
reg [5:0] curr_min;
reg [5:0] curr_hour;

// Next state logic
wire [5:0] next_sec = RST ? 6'd0 : 
                     (curr_sec == 6'd59) ? 6'd0 : curr_sec + 6'd1;

wire sec_rollover = (curr_sec == 6'd59);
wire [5:0] next_min = RST ? 6'd0 : 
                     sec_rollover ? 
                        ((curr_min == 6'd59) ? 6'd0 : curr_min + 6'd1) 
                     : curr_min;

wire min_rollover = (curr_min == 6'd59) & sec_rollover;
wire [5:0] next_hour = RST ? 6'd0 : 
                      (min_rollover) ? 
                         ((curr_hour[4:0] == 5'd23) ? 6'd0 : {1'b0, curr_hour[4:0] + 5'd1}) 
                      : curr_hour;

// Sequential update
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        curr_sec <= 6'd0;
        curr_min <= 6'd0;
        curr_hour <= 6'd0;
    end else begin
        curr_sec <= next_sec;
        curr_min <= next_min;
        curr_hour <= next_hour;
    end
end

// Output assignments
assign Secs = curr_sec;
assign Mins = curr_min;
assign Hours = curr_hour;

endmodule