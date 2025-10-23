module calendar (
    input  logic CLK,
    input  logic RST,
    output logic [5:0] Hours,
    output logic [5:0] Mins,
    output logic [5:0] Secs
);

always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else if (Secs == 6'd59) begin
        Secs <= 6'd0;
    end else begin
        Secs <= Secs + 1;
    end
end

always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (Secs == 6'd59) begin
        if (Mins == 6'd59) begin
            Mins <= 6'd0;
        end else begin
            Mins <= Mins + 1;
        end
    end else begin
        Mins <= Mins;
    end
end

always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if (Secs == 6'd59 && Mins == 6'd59) begin
        if (Hours == 6'd23) begin
            Hours <= 6'd0;
        end else begin
            Hours <= Hours + 1;
        end
    end else begin
        Hours <= Hours;
    end
end

endmodule