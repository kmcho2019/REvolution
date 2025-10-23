module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours,  // 0-23 requires 5 bits
    output reg  [5:0] Mins,   // 0-59 requires 6 bits
    output reg  [5:0] Secs    // 0-59 requires 6 bits
);

    localparam HOURS_MAX = 5'd23;
    localparam MINS_MAX  = 6'd59;
    localparam SECS_MAX  = 6'd59;

    // Seconds counter: increments every clock cycle, wraps at 59->0
    always @(posedge CLK) begin
        if (RST) begin
            Secs <= 6'd0;
        end else begin
            if (Secs == SECS_MAX) begin
                Secs <= 6'd0;
            end else begin
                Secs <= Secs + 6'd1;
            end
        end
    end

    // Minutes counter: increments when seconds wrap from 59->0, wraps at 59->0
    always @(posedge CLK) begin
        if (RST) begin
            Mins <= 6'd0;
        end else if (Secs == SECS_MAX) begin
            if (Mins == MINS_MAX) begin
                Mins <= 6'd0;
            end else begin
                Mins <= Mins + 6'd1;
            end
        end
    end

    // Hours counter: increments when minutes and seconds both wrap 59->0, wraps at 23->0
    always @(posedge CLK) begin
        if (RST) begin
            Hours <= 5'd0;
        end else if ((Mins == MINS_MAX) && (Secs == SECS_MAX)) begin
            if (Hours == HOURS_MAX) begin
                Hours <= 5'd0;
            end else begin
                Hours <= Hours + 5'd1;
            end
        end
    end

endmodule