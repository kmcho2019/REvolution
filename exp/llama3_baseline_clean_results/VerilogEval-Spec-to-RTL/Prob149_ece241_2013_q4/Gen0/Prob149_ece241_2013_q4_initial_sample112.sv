module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

always @ (posedge clk) begin
    if (reset) begin
        // Reset to a state equivalent to low water level
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        // Check current water level
        if (s[2] == 1'b1) begin
            // Water level is above the highest sensor
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s[1] == 1'b1 && s[0] == 1'b1) begin
            // Water level is between s[2] and s[1]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            // Check if level has increased
            if (prev_s < s) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s[0] == 1'b1) begin
            // Water level is between s[1] and s[0]
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            // Check if level has increased
            if (prev_s < s) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else begin
            // Water level is below s[0]
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            // Check if level has increased
            if (prev_s < s) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end
        
        // Update previous sensor state
        prev_s <= s;
    end
end

endmodule