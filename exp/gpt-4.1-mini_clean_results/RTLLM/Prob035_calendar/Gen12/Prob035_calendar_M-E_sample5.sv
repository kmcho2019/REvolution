module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 requires 5 bits
    output reg  [5:0] Mins,  // 0-59 requires 6 bits
    output reg  [5:0] Secs   // 0-59 requires 6 bits
);

    // Parameters for max values
    localparam SEC_MAX  = 6'd59;
    localparam MIN_MAX  = 6'd59;
    localparam HOUR_MAX = 5'd23;

    always @(posedge CLK) begin
        if (RST) begin
            Secs  <= 6'd0;
            Mins  <= 6'd0;
            Hours <= 5'd0;
        end else begin
            if (Secs == SEC_MAX) begin
                Secs <= 6'd0;
                if (Mins == MIN_MAX) begin
                    Mins <= 6'd0;
                    if (Hours == HOUR_MAX)
                        Hours <= 5'd0;
                    else
                        Hours <= Hours + 5'd1;
                end else begin
                    Mins <= Mins + 6'd1;
                end
            end else begin
                Secs <= Secs + 6'd1;
            end
        end
    end

endmodule