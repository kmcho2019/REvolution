module calendar(CLK, RST, Hours, Mins, Secs);
    input CLK, RST;
    output [5:0] Hours, Mins, Secs;
    reg [5:0] Hours, Mins, Secs;

    // Define states for seconds, minutes, and hours
    enum logic [1:0] {IDLE, UPDATE_MIN, UPDATE_HOUR} state;

    always @(posedge CLK or posedge RST)
    begin
        if (RST)
        begin
            Secs <= 0;
            Mins <= 0;
            Hours <= 0;
            state <= IDLE;
        end
        else
        begin
            case (state)
                IDLE:
                begin
                    if (Secs == 6'd59)
                    begin
                        Secs <= 0;
                        state <= UPDATE_MIN;
                    end
                    else
                    begin
                        Secs <= Secs + 1;
                    end
                end
                UPDATE_MIN:
                begin
                    if (Mins == 6'd59)
                    begin
                        Mins <= 0;
                        state <= UPDATE_HOUR;
                    end
                    else
                    begin
                        Mins <= Mins + 1;
                        state <= IDLE;
                    end
                end
                UPDATE_HOUR:
                begin
                    if (Hours == 6'd23)
                    begin
                        Hours <= 0;
                    end
                    else
                    begin
                        Hours <= Hours + 1;
                    end
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule