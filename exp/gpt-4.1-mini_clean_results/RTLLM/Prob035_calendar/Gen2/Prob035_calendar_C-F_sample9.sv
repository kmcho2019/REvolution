module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg [4:0]  Hours, // 5 bits for 0-23
    output reg [5:0]  Mins,
    output reg [5:0]  Secs
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs  <= 6'd0;
        Mins  <= 6'd0;
        Hours <= 5'd0;
    end else begin
        // Temporary next-state variables to reduce nested combinational logic
        reg [5:0] next_Secs;
        reg [5:0] next_Mins;
        reg [4:0] next_Hours;

        // Default assignments: hold current state
        next_Secs  = Secs;
        next_Mins  = Mins;
        next_Hours = Hours;

        // Increment seconds and check rollover
        if (Secs == 6'd59) begin
            next_Secs = 6'd0;

            // Increment minutes and check rollover
            if (Mins == 6'd59) begin
                next_Mins = 6'd0;

                // Increment hours and check rollover
                if (Hours == 5'd23) begin
                    next_Hours = 5'd0;
                end else begin
                    next_Hours = Hours + 5'd1;
                end
            end else begin
                next_Mins = Mins + 6'd1;
            end
        end else begin
            next_Secs = Secs + 6'd1;
        end

        // Update registers at end of clock cycle
        Secs  <= next_Secs;
        Mins  <= next_Mins;
        Hours <= next_Hours;
    end
end

endmodule