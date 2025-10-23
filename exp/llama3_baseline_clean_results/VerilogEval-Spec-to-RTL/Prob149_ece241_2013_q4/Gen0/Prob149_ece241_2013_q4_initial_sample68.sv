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
reg [2:0] curr_s;

always @(posedge clk) begin
    if (reset) begin
        // Reset to a state equivalent to a low water level
        prev_s <= 3'b000;
        curr_s <= 3'b000;
        fr0 <= 1'b1;
        fr1 <= 1'b1;
        fr2 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Update previous sensor state
        prev_s <= curr_s;
        
        // Update current sensor state
        curr_s <= s;

        // Determine flow rate based on current water level
        if (s == 3'b111) begin
            // Water level is above the highest sensor
            fr0 <= 1'b0;
            fr1 <= 1'b0;
            fr2 <= 1'b0;
            dfr <= 1'b0;
        end else if (s == 3'b110) begin
            // Water level is between the highest and middle sensors
            fr0 <= 1'b1;
            fr1 <= 1'b0;
            fr2 <= 1'b0;
            // Check if previous level was lower
            if ((prev_s == 3'b101) || (prev_s == 3'b100) || (prev_s == 3'b000)) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s == 3'b101) begin
            // Water level is between the middle and lower sensors
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b0;
            // Check if previous level was lower
            if ((prev_s == 3'b100) || (prev_s == 3'b000)) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s == 3'b100) begin
            // Water level is below the lower sensor
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end else if (s == 3'b000) begin
            // Water level is below the lower sensor
            fr0 <= 1'b1;
            fr1 <= 1'b1;
            fr2 <= 1'b1;
            dfr <= 1'b1;
        end
    end
end

endmodule