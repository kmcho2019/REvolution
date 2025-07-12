module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Previous sensor values
reg [2:0] previous_s;

always @(posedge clk) begin
    if (reset) begin
        // Reset all outputs to the state equivalent to a low water level
        previous_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Store the current sensor values as the previous values for the next clock cycle
        previous_s <= s;

        // Determine the 'fr2', 'fr1', and 'fr0' outputs based on the current sensor values
        case ({s[2], s[1], s[0]})
            3'b111: begin
                // Water level is above the highest sensor
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
            3'b110, 3'b101: begin
                // Water level is between the highest and middle sensors
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            3'b100, 3'b011, 3'b010: begin
                // Water level is between the middle and lowest sensors
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            3'b001: begin
                // Water level is between the lowest sensor and below
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            default: begin
                // Water level is below the lowest sensor
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
        endcase

        // Determine the 'dfr' output based on the current and previous sensor values
        dfr <= (s[2] &&!previous_s[2]) || (s[1] &&!previous_s[1]) || (s[0] &&!previous_s[0]);
    end
end

endmodule