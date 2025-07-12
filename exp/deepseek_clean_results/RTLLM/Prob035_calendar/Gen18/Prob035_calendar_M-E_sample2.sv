module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// 17-bit counter (0 to 86399)
reg [16:0] time_counter;

// Clock gating control
wire counter_enable = ~RST;

// Time constants
parameter MAX_TIME = 17'd86399;  // 23:59:59 in seconds

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        time_counter <= 17'd0;
    end else if (counter_enable) begin
        time_counter <= (time_counter == MAX_TIME) ? 17'd0 : time_counter + 17'd1;
    end
end

// Continuous decoding of time components
always @(*) begin
    // Calculate seconds
    Secs = time_counter % 17'd60;
    
    // Calculate minutes
    Mins = (time_counter / 17'd60) % 17'd60;
    
    // Calculate hours
    Hours = time_counter / 17'd3600;
end

endmodule