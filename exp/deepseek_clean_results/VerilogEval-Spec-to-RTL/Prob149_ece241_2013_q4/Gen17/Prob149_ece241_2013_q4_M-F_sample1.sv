module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    // State encoding
    localparam BELOW   = 2'b00; // Below s[0]
    localparam MIDDLE  = 2'b01; // Between s[1] and s[0]
    localparam HIGH    = 2'b10; // Between s[2] and s[1]
    localparam ABOVE   = 2'b11; // Above s[2]

    reg [1:0] current_state, next_state;
    reg [1:0] prev_state;
    reg rising;

    // State transition logic
    always @(*) begin
        casez (s)
            3'b000: next_state = BELOW;   // No sensors
            3'b001: next_state = MIDDLE;  // Only s[0]
            3'b011: next_state = HIGH;    // s[1] and s[0]
            3'b111: next_state = ABOVE;   // All sensors
            default: next_state = BELOW;  // Handle other cases as below
        endcase
    end

    // State registers and edge detection
    always @(posedge clk) begin
        if (reset) begin
            current_state <= BELOW;
            prev_state <= BELOW;
            rising <= 1'b0;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
            rising <= (next_state > current_state);
        end
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            {fr2, fr1, fr0, dfr} <= 4'b1111;
        end else begin
            // Nominal flow outputs
            fr0 <= (current_state <= HIGH);
            fr1 <= (current_state <= MIDDLE);
            fr2 <= (current_state == BELOW);
            
            // Supplemental flow (rising edge)
            dfr <= rising;
        end
    end

endmodule