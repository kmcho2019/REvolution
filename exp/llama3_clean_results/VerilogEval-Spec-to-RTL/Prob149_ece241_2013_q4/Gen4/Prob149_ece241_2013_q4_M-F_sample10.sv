module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        // Update previous sensor value only when it changes
        if (s != prev_s) begin
            prev_s <= s;
        end

        // Determine output signals based on sensor inputs
        if (s == 3'b111) begin // Above s[2]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s == 3'b110) begin // Between s[2] and s[1]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            // dfr is high if water level has risen
            dfr <= (prev_s == 3'b101) || (prev_s == 3'b100) || (prev_s == 3'b000);
        end else if (s == 3'b101) begin // Between s[1] and s[0]
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            // dfr is high if water level has risen
            dfr <= (prev_s == 3'b100) || (prev_s == 3'b000);
        end else if (s == 3'b100) begin // At s[0]
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            // dfr is high if water level has risen
            dfr <= (prev_s == 3'b000);
        end else begin // Below s[0]
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end
    end
end

endmodule