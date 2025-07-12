module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to water level being low for a long time
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        if (s[2]) begin
            // Water level is above the highest sensor
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s[1]) begin
            // Water level is between the upper and middle sensors
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            // Check previous state to determine if supplemental flow valve should be opened
            // This can be achieved by using a register to store the previous state
            // For simplicity, we assume that the previous state is stored in a register named prev_s
            // We also assume that prev_s is updated at the end of the always block
            if (s[0] && (s != prev_s)) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s[0]) begin
            // Water level is between the middle and lower sensors
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            // Check previous state to determine if supplemental flow valve should be opened
            if (s[0] && (s != prev_s)) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else begin
            // Water level is below the lowest sensor
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end
    end
    // Update previous state
    prev_s <= s;
end

reg [2:0] prev_s;

initial begin
    prev_s = 3'b0;
end

endmodule