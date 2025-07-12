module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours, // Using 6 bits for output consistency (only 0-23 used)
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
        Mins  <= 6'd0;
        Secs  <= 6'd0;
    end else begin
        // Temp vars for next state
        reg [5:0] next_secs;
        reg [5:0] next_mins;
        reg [5:0] next_hours;

        next_secs = Secs + 6'd1;
        next_mins = Mins;
        next_hours = Hours;

        if (next_secs == 6'd60) begin
            next_secs = 6'd0;
            next_mins = Mins + 6'd1;
            if (next_mins == 6'd60) begin
                next_mins = 6'd0;
                next_hours = Hours + 6'd1;
                if (next_hours == 6'd24) begin
                    next_hours = 6'd0;
                end
            end
        end

        Secs  <= next_secs;
        Mins  <= next_mins;
        Hours <= next_hours;
    end
end

endmodule