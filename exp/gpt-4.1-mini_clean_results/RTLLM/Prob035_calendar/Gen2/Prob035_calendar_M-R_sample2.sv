module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg [5:0]  Hours,
    output reg [5:0]  Mins,
    output reg [5:0]  Secs
);

    // Combinational signals for next values
    reg [5:0] next_secs;
    reg [5:0] next_mins;
    reg [5:0] next_hours;

    always @(*) begin
        // Default next values are current values
        next_secs  = Secs;
        next_mins  = Mins;
        next_hours = Hours;

        if (Secs == 6'd59) begin
            next_secs = 6'd0;
            if (Mins == 6'd59) begin
                next_mins = 6'd0;
                if (Hours == 6'd23) begin
                    next_hours = 6'd0;
                end else begin
                    next_hours = Hours + 6'd1;
                end
            end else begin
                next_mins = Mins + 6'd1;
            end
        end else begin
            next_secs = Secs + 6'd1;
        end
    end

    // Sequential update
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Hours <= 6'd0;
            Mins  <= 6'd0;
            Secs  <= 6'd0;
        end else begin
            Hours <= next_hours;
            Mins  <= next_mins;
            Secs  <= next_secs;
        end
    end

endmodule