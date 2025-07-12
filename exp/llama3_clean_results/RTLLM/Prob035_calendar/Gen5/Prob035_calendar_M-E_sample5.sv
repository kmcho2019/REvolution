module calendar(
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

reg [1:0] state; // 0: idle, 1: increment_minutes, 2: increment_hours

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 0;
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        case (state)
            0: begin // idle
                if (Secs == 6'd59) begin
                    state <= 1;
                    Secs <= 6'd0;
                    Mins <= Mins + 6'd1;
                end else begin
                    Secs <= Secs + 6'd1;
                end
            end
            1: begin // increment_minutes
                if (Mins == 6'd59) begin
                    state <= 2;
                    Mins <= 6'd0;
                    Hours <= Hours + 5'd1;
                end else begin
                    state <= 0;
                end
            end
            2: begin // increment_hours
                if (Hours == 5'd23) begin
                    Hours <= 5'd0;
                end
                state <= 0;
            end
        endcase
    end
end

endmodule