module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg [4:0]  Hours,
    output reg [5:0]  Mins,
    output reg [5:0]  Secs
);

// Increment enable signal: increment counters only if not resetting
wire inc_enable = ~RST;

always @(posedge CLK) begin
    if (RST) begin
        Hours <= 5'd0;
        Mins  <= 6'd0;
        Secs  <= 6'd0;
    end else if (inc_enable) begin
        if (Secs == 6'd59) begin
            Secs <= 6'd0;
            if (Mins == 6'd59) begin
                Mins <= 6'd0;
                if (Hours == 5'd23) begin
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