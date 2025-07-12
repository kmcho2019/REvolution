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
        // Reset to state equivalent to water level below the lowest sensor
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        // Determine nominal flow rate
        if (s == 3'b111) begin
            // Water level above the highest sensor
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
        end else if (s == 3'b110) begin
            // Water level between the upper and middle sensors
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
        end else if (s == 3'b100) begin
            // Water level between the middle and lower sensors
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end else begin
            // Water level below the lowest sensor
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end
        
        // Determine supplemental flow rate
        if ((s > prev_s) && (s != 3'b000)) begin
            // Open supplemental flow valve if water level increased
            dfr <= 1'b1;
        end else begin
            // Close supplemental flow valve if water level decreased or stayed the same
            dfr <= 1'b0;
        end
        
        // Update previous sensor values
        prev_s <= s;
    end
end

endmodule