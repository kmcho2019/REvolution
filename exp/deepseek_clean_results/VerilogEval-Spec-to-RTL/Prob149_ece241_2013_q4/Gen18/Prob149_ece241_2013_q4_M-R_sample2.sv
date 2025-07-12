module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // One-hot state encoding
    localparam STATE_BELOW = 3'b001;  // Below s[0]
    localparam STATE_LOW   = 3'b010;  // Between s[1] and s[0]
    localparam STATE_MID   = 3'b100;  // Between s[2] and s[1]
    // Above s[2] is represented by all zeros

    reg [2:0] current_state, next_state, prev_state;

    // Next state logic (combinational)
    always @(*) begin
        casez(s)
            3'b000: next_state = STATE_BELOW;  // No sensors
            3'b001: next_state = STATE_LOW;    // Only s[0]
            3'b011: next_state = STATE_MID;    // s[0] and s[1]
            3'b111: next_state = 3'b000;       // All sensors (above)
            default: next_state = current_state;
        endcase
    end

    // State registers
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW;
            prev_state <= STATE_BELOW;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
        end
    end

    // Output logic
    assign fr0 = (current_state != 3'b000);  // Not above s[2]
    assign fr1 = (current_state[1] | current_state[0]);  // LOW or BELOW
    assign fr2 = current_state[0];           // BELOW
    assign dfr = (current_state > prev_state);  // Any rising transition

endmodule