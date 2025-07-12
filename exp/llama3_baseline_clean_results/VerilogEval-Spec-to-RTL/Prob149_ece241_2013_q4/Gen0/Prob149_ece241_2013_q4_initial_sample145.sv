module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s,  // sensor inputs
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s;  // previous sensor inputs
reg prev_fr2, prev_fr1, prev_fr0;  // previous flow rate outputs
reg prev_dfr;  // previous supplemental flow rate output

always @ (posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to water level being low for a long time
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
        prev_fr2 <= 1'b1;
        prev_fr1 <= 1'b1;
        prev_fr0 <= 1'b1;
        prev_dfr <= 1'b1;
    end else begin
        // Update previous sensor inputs and flow rate outputs
        prev_s <= s;
        prev_fr2 <= fr2;
        prev_fr1 <= fr1;
        prev_fr0 <= fr0;
        prev_dfr <= dfr;

        // Determine current flow rate based on sensor inputs and previous level
        if (s == 3'b111) begin
            // Water level above s[2]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s == 3'b110) begin
            // Water level between s[2] and s[1]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            if (prev_s < s) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s == 3'b100) begin
            // Water level between s[1] and s[0]
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if (prev_s < s) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s == 3'b000) begin
            // Water level below s[0]
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Other cases (e.g., s == 3'b001, s == 3'b010, s == 3'b011)
            // Handle these cases based on the specific requirements
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end
    end
end

endmodule