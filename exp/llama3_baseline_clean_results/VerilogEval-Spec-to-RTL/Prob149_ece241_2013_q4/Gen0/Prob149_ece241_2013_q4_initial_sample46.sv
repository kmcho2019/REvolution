module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s;
reg prev_fr2, prev_fr1, prev_fr0, prev_dfr;

always @ (posedge clk) begin
    if (reset) begin
        prev_s <= 3'b000;
        prev_fr2 <= 1'b1;
        prev_fr1 <= 1'b1;
        prev_fr0 <= 1'b1;
        prev_dfr <= 1'b1;
    end else begin
        prev_s <= s;
        prev_fr2 <= fr2;
        prev_fr1 <= fr1;
        prev_fr0 <= fr0;
        prev_dfr <= dfr;
    end
end

always @ (*) begin
    if (s == 3'b111) begin // above s2
        fr2 = 1'b0;
        fr1 = 1'b0;
        fr0 = 1'b0;
        dfr = 1'b0;
    end else if (s == 3'b110) begin // between s2 and s1
        fr2 = 1'b0;
        fr1 = 1'b0;
        fr0 = 1'b1;
        if ((prev_s == 3'b101) || (prev_s == 3'b100) || (prev_s == 3'b000)) begin
            dfr = 1'b1;
        end else begin
            dfr = 1'b0;
        end
    end else if (s == 3'b101) begin // between s1 and s0
        fr2 = 1'b0;
        fr1 = 1'b1;
        fr0 = 1'b1;
        if ((prev_s == 3'b100) || (prev_s == 3'b000)) begin
            dfr = 1'b1;
        end else begin
            dfr = 1'b0;
        end
    end else if (s == 3'b100) begin // below s0 but above the previous state
        fr2 = 1'b1;
        fr1 = 1'b1;
        fr0 = 1'b1;
        if ((prev_s == 3'b000)) begin
            dfr = 1'b1;
        end else begin
            dfr = 1'b0;
        end
    end else begin // below s0
        fr2 = 1'b1;
        fr1 = 1'b1;
        fr0 = 1'b1;
        dfr = 1'b0;
    end
end

endmodule