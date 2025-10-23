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
    end else if (s != prev_s) begin
        // Update previous sensor state only when it changes
        prev_s <= s;
    end
end

// Determine output signals based on sensor inputs
always @(*) begin
    casez ({s[2], s[1], s[0]})
        3'b111: begin // Water level above the highest sensor
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
            dfr = 1'b0;
        end
        3'b11?: begin // Water level between the highest and middle sensors
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
            dfr = (prev_s < s) ? 1'b1 : 1'b0;
        end
        3'b1?0: begin // Water level between the middle and lowest sensors
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = (prev_s < s) ? 1'b1 : 1'b0;
        end
        3'b0??: begin // Water level below the lowest sensor or at it
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = (prev_s < s) ? 1'b1 : 1'b0;
        end
        default: begin // Should not occur, but handle for completeness
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
            dfr = 1'b1;
        end
    endcase
end

endmodule