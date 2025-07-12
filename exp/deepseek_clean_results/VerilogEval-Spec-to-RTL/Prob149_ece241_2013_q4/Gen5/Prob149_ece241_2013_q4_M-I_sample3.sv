module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // Water level encoding (0=lowest, 3=highest)
    reg [1:0] current_level, prev_level;

    // Next level calculation (strictly follows problem description)
    wire [1:0] next_level;
    assign next_level = (s == 3'b000) ? 2'b00 :  // Below s[0]
                       (s == 3'b001) ? 2'b01 :  // Between s[0]-s[1]
                       (s == 3'b011) ? 2'b10 :  // Between s[1]-s[2]
                       (s == 3'b111) ? 2'b11 :  // Above s[2]
                       2'b00;                  // Default to lowest level

    // State tracking
    always @(posedge clk) begin
        if (reset) begin
            current_level <= 2'b00;
            prev_level <= 2'b00;
        end else begin
            prev_level <= current_level;
            current_level <= next_level;
        end
    end

    // Output logic (strictly follows problem requirements)
    always @(posedge clk) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            // Nominal flow rates
            fr0 <= (current_level == 2'b00) || (current_level == 2'b01);
            fr1 <= (current_level == 2'b00);
            fr2 <= (current_level == 2'b00);
            
            // Supplemental flow (was level increasing?)
            dfr <= (current_level > prev_level);
        end
    end

endmodule