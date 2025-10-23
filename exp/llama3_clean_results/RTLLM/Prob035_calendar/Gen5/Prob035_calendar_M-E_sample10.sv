module calendar (
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

parameter SEC_MAX = 59;
parameter MIN_MAX = 59;
parameter HOUR_MAX = 23;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        case ({Secs, Mins, Hours})
            {SEC_MAX, MIN_MAX, HOUR_MAX}: begin
                Secs <= 6'd0;
                Mins <= 6'd0;
                Hours <= 5'd0;
            end
            {SEC_MAX, MIN_MAX, {5{1'b0}}}: begin
                Secs <= 6'd0;
                Mins <= 6'd0;
                Hours <= Hours + 1'd1;
            end
            {SEC_MAX, {6{1'b0}}}: begin
                Secs <= 6'd0;
                Mins <= Mins + 1'd1;
                Hours <= Hours;
            end
            default: begin
                Secs <= Secs + 1'd1;
                Mins <= Mins;
                Hours <= Hours;
            end
        endcase
    end
end

endmodule