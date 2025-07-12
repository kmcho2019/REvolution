module calendar(CLK, RST, Hours, Mins, Secs);

    input CLK;
    input RST;
    output [5:0] Hours;
    output [5:0] Mins;
    output [5:0] Secs;
    reg [5:0] Hours;
    reg [5:0] Mins;
    reg [5:0] Secs;

    always @(posedge CLK or posedge RST) begin
        if(RST) begin
            Secs <= 0;
        end
        else if(Secs == 59) begin
            Secs <= 0;
        end
        else begin
            Secs <= Secs + 1;
        end
    end

    always @(posedge CLK or posedge RST) begin
        if(RST) begin
            Mins <= 0;
        end
        else if(Secs == 59 && Mins == 59) begin
            Mins <= 0;
        end
        else if(Secs == 59) begin
            Mins <= Mins + 1;
        end
        else begin
            Mins <= Mins;
        end
    end

    always @(posedge CLK or posedge RST) begin
        if(RST) begin
            Hours <= 0;
        end
        else if(Secs == 59 && Mins == 59 && Hours == 23) begin
            Hours <= 0;
        end
        else if(Secs == 59 && Mins == 59) begin
            Hours <= Hours + 1;
        end
        else begin
            Hours <= Hours;
        end
    end

endmodule