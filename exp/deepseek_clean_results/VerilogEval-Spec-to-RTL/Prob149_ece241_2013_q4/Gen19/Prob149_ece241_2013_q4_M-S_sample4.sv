module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Binary state encoding (matches water level ordering)
    localparam BELOW = 2'b00;  // Below s[0]
    localparam LOW   = 2'b01;  // Between s[1] and s[0]
    localparam MID   = 2'b10;  // Between s[2] and s[1]
    localparam ABOVE = 2'b11;  // Above s[2]

    reg [1:0] state;

    // Next state logic (priority encoder)
    wire [1:0] next_state = 
        (s == 3'b000) ? BELOW :  // No sensors
        (s == 3'b001) ? LOW   :  // Only s[0]
        (s == 3'b011) ? MID   :  // s[0] and s[1]
        ABOVE;                   // All other cases (3'b111)

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= BELOW;
        else
            state <= next_state;
    end

    // Output logic
    assign fr0 = (state != ABOVE);         // Not above s[2]
    assign fr1 = (state == BELOW || state == LOW); // Below or low
    assign fr2 = (state == BELOW);         // Only below
    assign dfr = (next_state > state);     // Rising water level

endmodule