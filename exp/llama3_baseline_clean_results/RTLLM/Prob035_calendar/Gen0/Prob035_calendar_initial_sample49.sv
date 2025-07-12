module calendar(CLK, RST, Hours, Mins, Secs);
    input CLK, RST;
    output [5:0] Hours, Mins, Secs;
    reg [5:0] Hours, Mins, Secs;

    always @(posedge CLK or posedge RST)
    begin
        if(RST)
        begin
            Secs <= 0;
        end
        else
        begin
            if(Secs == 6'd59)
            begin
                Secs <= 0;
            end
            else
            begin
                Secs <= Secs + 1;
            end
        end
    end

    always @(posedge CLK or posedge RST)
    begin
        if(RST)
        begin
            Mins <= 0;
        end
        else
        begin
            if(Secs == 6'd59)
            begin
                if(Mins == 6'd59)
                begin
                    Mins <= 0;
                end
                else
                begin
                    Mins <= Mins + 1;
                end
            end
        end
    end

    always @(posedge CLK or posedge RST)
    begin
        if(RST)
        begin
            Hours <= 0;
        end
        else
        begin
            if((Mins == 6'd59) && (Secs == 6'd59))
            begin
                if(Hours == 6'd23)
                begin
                    Hours <= 0;
                end
                else
                begin
                    Hours <= Hours + 1;
                end
            end
        end
    end
endmodule