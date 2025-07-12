module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Determine the current state based on the sensor inputs
wire above_s2 = s[2] & s[1] & s[0];
wire between_s2_s1 = s[1] & s[0] & ~s[2];
wire between_s1_s0 = s[0] & ~s[1] & ~s[2];
wire below_s0 = ~s[0] & ~s[1] & ~s[2];

reg [2:0] prev_s;

// Determine the current flow rate based on the current state
always @ (posedge clk) begin
    if (reset) begin
        // Reset to the state equivalent to a low water level
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Determine the current state and set the output flow rates
        if (above_s2) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (between_s2_s1) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            // Check if the water level is rising
            if ({s[0], s[1], s[2]} > prev_s) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (between_s1_s0) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            // Check if the water level is rising
            if ({s[0], s[1], s[2]} > prev_s) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (below_s0) begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end
        // Update the previous sensor state
        prev_s <= {s[0], s[1], s[2]};
    end
end

endmodule