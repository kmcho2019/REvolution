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

always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to water level being low for a long time
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        // Determine current state based on sensor inputs
        if (s == 3'b111) begin
            // Water level is above s[2]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s == 3'b110) begin
            // Water level is between s[2] and s[1]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            // Check if water level is increasing
            if (prev_s < s) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s == 3'b100) begin
            // Water level is between s[1] and s[0]
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            // Check if water level is increasing
            if (prev_s < s) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s == 3'b000) begin
            // Water level is below s[0]
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end
        prev_s <= s;
    end
end

endmodule