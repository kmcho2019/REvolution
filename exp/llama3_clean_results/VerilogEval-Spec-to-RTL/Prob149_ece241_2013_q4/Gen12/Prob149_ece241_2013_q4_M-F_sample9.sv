module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s; // Register to store previous sensor state

always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        prev_s <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Determine output signals based on sensor inputs
        casez ({s[2], s[1], s[0]})
            3'b111: begin // Water level above the highest sensor
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            3'b110: begin // Water level between the highest and middle sensors
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= ({s[2], s[1], s[0]} > prev_s); // Check if level is rising
            end
            3'b100: begin // Incorrect case, s[1] cannot be 0 if s[2] is 1, handle as 3'b110
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= ({s[2], s[1], s[0]} > prev_s);
            end
            3'b011: begin // Water level between the middle and lowest sensors
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= ({s[2], s[1], s[0]} > prev_s);
            end
            3'b010: begin // This case should not occur as s[2] should be 1 if s[1] is 1, handle as 3'b011
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= ({s[2], s[1], s[0]} > prev_s);
            end
            3'b001: begin // Water level below the lowest sensor
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1; // Always high when water level is low
            end
            default: begin // Water level below the lowest sensor
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1; // Ensure dfr is always high when water level is low
            end
        endcase
        prev_s <= s; // Update previous state
    end
end

endmodule