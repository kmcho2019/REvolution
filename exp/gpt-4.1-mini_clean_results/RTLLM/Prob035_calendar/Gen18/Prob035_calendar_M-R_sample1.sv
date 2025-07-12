module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 requires 5 bits
    output reg  [5:0] Mins,  // 0-59 requires 6 bits
    output reg  [5:0] Secs   // 0-59 requires 6 bits
);

    // Next state registers
    reg [5:0] next_secs;
    reg [5:0] next_mins;
    reg [4:0] next_hours;

    // Combinational logic: Calculate next state
    always @(*) begin
        // Default: maintain current state
        next_secs  = Secs;
        next_mins  = Mins;
        next_hours = Hours;

        if (Secs == 6'd59) begin
            next_secs = 6'd0;
            if (Mins == 6'd59) begin
                next_mins = 6'd0;
                if (Hours == 5'd23) begin
                    next_hours = 5'd0;
                end else begin
                    next_hours = Hours + 5'd1;
                end
            end else begin
                next_mins = Mins + 6'd1;
            end
        end else begin
            next_secs = Secs + 6'd1;
        end
    end

    // Sequential logic: Update state registers
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs  <= 6'd0;
            Mins  <= 6'd0;
            Hours <= 5'd0;
        end else begin
            // Update only if values changed to reduce toggling
            if (Secs != next_secs)
                Secs <= next_secs;
            if (Mins != next_mins)
                Mins <= next_mins;
            if (Hours != next_hours)
                Hours <= next_hours;
        end
    end

endmodule