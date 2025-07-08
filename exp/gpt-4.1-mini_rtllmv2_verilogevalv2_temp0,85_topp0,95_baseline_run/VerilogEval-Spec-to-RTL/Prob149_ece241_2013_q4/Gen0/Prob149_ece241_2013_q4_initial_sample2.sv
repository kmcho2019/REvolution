module TopModule (
    input  wire       clk,
    input  wire       reset,
    input  wire [2:0] s,
    output reg        fr2,
    output reg        fr1,
    output reg        fr0,
    output reg        dfr
);

// Water level encoding
localparam BELOW    = 2'd0;
localparam BETWEEN_10 = 2'd1; // between s[1] and s[0]
localparam BETWEEN_21 = 2'd2; // between s[2] and s[1]
localparam ABOVE    = 2'd3;

// Registers to hold current and previous water levels
reg [1:0] current_level, previous_level;

// Function to determine water level from sensors
function [1:0] get_level;
    input [2:0] sensors;
    begin
        if (sensors == 3'b111)
            get_level = ABOVE;        // Above s[2]
        else if (sensors[2:1] == 2'b11 && sensors[0] == 1'b0)
            // This case won't happen as sensors are vertical and contiguous,
            // but just in case, handle it logically:
            get_level = ABOVE;
        else if (sensors[2] == 0 && sensors[1] == 1 && sensors[0] == 1)
            get_level = BETWEEN_21;   // between s[2] and s[1]
        else if (sensors[2] == 0 && sensors[1] == 0 && sensors[0] == 1)
            get_level = BETWEEN_10;   // between s[1] and s[0]
        else if (sensors == 3'b000)
            get_level = BELOW;        // below s[0]
        else if (sensors == 3'b001)
            get_level = BETWEEN_10;   // only s[0] asserted, same as between s[1] and s[0]
        else if (sensors == 3'b011)
            get_level = BETWEEN_21;   // s[0], s[1] asserted (between s[2] and s[1])
        else if (sensors == 3'b111)
            get_level = ABOVE;
        else
            // For any other pattern, determine the highest asserted sensor:
            begin
                if (sensors[2]) get_level = ABOVE;
                else if (sensors[1]) get_level = BETWEEN_21;
                else if (sensors[0]) get_level = BETWEEN_10;
                else get_level = BELOW;
            end
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        // Reset to below s[0] state: no sensors asserted, all outputs asserted
        current_level  <= BELOW;
        previous_level <= BELOW;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // Determine current level based on sensors
        current_level <= get_level(s);

        // On a level change, update previous_level to old current_level
        if (get_level(s) != current_level) begin
            previous_level <= current_level;
        end

        // Determine if water level increased (previous lower than current)
        // and assign outputs accordingly
        // NOTE: We do not update previous_level until next clock, so here
        // previous_level still the old value before current_level update.
        // So we compare previous_level and current_level after updating current_level.

        // Compare previous_level and current_level:
        // If current_level > previous_level => water level rising
        // else falling or steady (only rising triggers dfr)

        // Because current_level was updated in this clock, 
        // we need to compare new current_level and old previous_level.

        // But since current_level updated first here, and previous_level update depends on change,
        // we do the logic in two steps.

        // We create temporary variables for clarity.

        // To avoid combinational loops, we'll use variables here

        // Because current_level and previous_level are reg, updated on posedge clk,
        // their old values are used within always block (nonblocking assignments).

        // So, let's compute in sequential order:

        // Capture previous values:
        // Let's use temporary variables.

        // However, Verilog nonblocking assignments mean that new values take effect after always block,
        // so within this always block, current_level and previous_level hold old values.

        // So to get the current_level after update, we use get_level(s) again.

        // Water level after input change:
        reg [1:0] new_level;
        new_level = get_level(s);

        // Water level rising if new_level > previous_level
        // (previous_level is old, new_level is current)

        // Nominal flow rates and supplemental valve logic:
        case (new_level)
            ABOVE: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
            BETWEEN_21: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            BETWEEN_10: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            BELOW: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            default: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
        endcase

        // Supplemental valve control: open (1) if water level rose (new_level > previous_level)
        dfr <= (new_level > previous_level) ? 1'b1 : 1'b0;

        // Update current and previous level registers
        if (new_level != current_level)
            previous_level <= current_level;
        current_level <= new_level;
    end
end

endmodule