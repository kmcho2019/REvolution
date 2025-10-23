module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 fits in 5 bits
    output reg  [5:0] Mins,  // 0-59 fits in 6 bits
    output reg  [5:0] Secs   // 0-59 fits in 6 bits
);

localparam [5:0] SEC_MAX = 6'd59;
localparam [5:0] MIN_MAX = 6'd59;
localparam [4:0] HR_MAX  = 5'd23;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs  <= 6'd0;
        Mins  <= 6'd0;
        Hours <= 5'd0;
    end else begin
        // Increment seconds and cascade increments if overflow occurs
        if (Secs == SEC_MAX) begin
            Secs <= 6'd0;
            if (Mins == MIN_MAX) begin
                Mins <= 6'd0;
                if (Hours == HR_MAX) begin
                    Hours <= 5'd0;
                end else begin
                    Hours <= Hours + 5'd1;
                end
            end else begin
                Mins <= Mins + 6'd1;
            end
        end else begin
            Secs <= Secs + 6'd1;
        end
    end
end

endmodule