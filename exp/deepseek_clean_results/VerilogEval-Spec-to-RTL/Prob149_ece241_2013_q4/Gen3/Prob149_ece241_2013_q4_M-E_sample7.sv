module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Current and previous water level indicators
    reg [1:0] current_level, prev_level;

    // Priority encoder for water level
    always @(*) begin
        casez (s)
            3'b1??: current_level = 2'b00;  // Above s[2]
            3'b01?: current_level = 2'b01;  // Between s[2] and s[1]
            3'b001: current_level = 2'b10;  // Between s[1] and s[0]
            3'b000: current_level = 2'b11;  // Below s[0]
            default: current_level = 2'b11; // Invalid -> assume lowest
        endcase
    end

    // Level history register
    always @(posedge clk) begin
        if (reset) begin
            prev_level <= 2'b11; // Reset to below s[0] state
        end else begin
            prev_level <= current_level;
        end
    end

    // Nominal flow outputs (combinatorial)
    assign fr0 = (current_level >= 2'b01); // Level 01,10,11
    assign fr1 = (current_level >= 2'b10); // Level 10,11
    assign fr2 = (current_level == 2'b11); // Level 11 only

    // Supplemental flow (rising water level detected)
    assign dfr = (current_level < prev_level); // Current higher than previous

endmodule