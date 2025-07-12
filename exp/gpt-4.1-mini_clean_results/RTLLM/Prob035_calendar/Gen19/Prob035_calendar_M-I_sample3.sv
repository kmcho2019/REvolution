module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours,  // 0-23 range requires 5 bits
    output reg  [5:0] Mins,   // 0-59 range requires 6 bits
    output reg  [5:0] Secs    // 0-59 range requires 6 bits
);

    // Parameters for maximum counts
    localparam HOURS_MAX = 5'd23;
    localparam MINS_MAX  = 6'd59;
    localparam SECS_MAX  = 6'd59;

    // Treat time as single 17-bit number: {Hours[4:0], Mins[5:0], Secs[5:0]}
    // Max value corresponds to 23:59:59 = 17'd( (23<<12) + (59<<6) + 59 )
    localparam [16:0] TIME_MAX = {HOURS_MAX, MINS_MAX, SECS_MAX};

    // Concatenate current time for arithmetic
    wire [16:0] current_time = {Hours, Mins, Secs};

    // Next time value, default increment by one second
    reg [16:0] next_time;

    always @(posedge CLK) begin
        if (RST) begin
            // Synchronous reset to 00:00:00
            Hours <= 5'd0;
            Mins  <= 6'd0;
            Secs  <= 6'd0;
        end else begin
            if (current_time == TIME_MAX)
                next_time = 17'd0;  // Wrap around after 23:59:59
            else
                next_time = current_time + 17'd1;  // Increment by 1 second

            // Split next_time back into Hours, Mins, Secs
            Hours <= next_time[16:12];
            Mins  <= next_time[11:6];
            Secs  <= next_time[5:0];
        end
    end

endmodule