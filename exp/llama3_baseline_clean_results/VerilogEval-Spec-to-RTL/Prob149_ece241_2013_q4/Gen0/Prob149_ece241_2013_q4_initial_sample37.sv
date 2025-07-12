module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s;
reg [2:0] curr_s;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        prev_s <= 3'b000;
        curr_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_s <= curr_s;
        curr_s <= s;
        
        if (s == 3'b111) begin // above all sensors
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s == 3'b110) begin // between s[2] and s[1]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            dfr <= (prev_s < curr_s) ? 1'b1 : 1'b0;
        end else if (s == 3'b100) begin // between s[1] and s[0]
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= (prev_s < curr_s) ? 1'b1 : 1'b0;
        end else if (s == 3'b001) begin // below all sensors
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin // s[0] is high, s[1] and s[2] are low
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= (prev_s < curr_s) ? 1'b1 : 1'b0;
        end
    end
end

endmodule