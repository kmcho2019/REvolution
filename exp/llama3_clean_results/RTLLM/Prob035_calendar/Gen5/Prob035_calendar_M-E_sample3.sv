module calendar(
    input CLK,
    input RST,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

// Define the states of the FSM
enum logic [1:0] {
    NORMAL,
    MINUTE_WRAP,
    HOUR_WRAP
} state;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= NORMAL;
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        case (state)
            NORMAL: begin
                if (Secs == 6'd59) begin
                    if (Mins == 6'd59) begin
                        if (Hours == 5'd23) begin
                            state <= NORMAL;
                            Secs <= 6'd0;
                            Mins <= 6'd0;
                            Hours <= 5'd0;
                        end else begin
                            state <= HOUR_WRAP;
                            Secs <= 6'd0;
                            Mins <= 6'd0;
                            Hours <= Hours + 1'd1;
                        end
                    end else begin
                        state <= MINUTE_WRAP;
                        Secs <= 6'd0;
                        Mins <= Mins + 1'd1;
                    end
                end else begin
                    Secs <= Secs + 1'd1;
                end
            end
            MINUTE_WRAP: begin
                state <= NORMAL;
                Secs <= 6'd0;
                Mins <= Mins + 1'd1;
            end
            HOUR_WRAP: begin
                state <= NORMAL;
                Secs <= 6'd0;
                Mins <= 6'd0;
                Hours <= Hours + 1'd1;
            end
        endcase
    end
end

endmodule