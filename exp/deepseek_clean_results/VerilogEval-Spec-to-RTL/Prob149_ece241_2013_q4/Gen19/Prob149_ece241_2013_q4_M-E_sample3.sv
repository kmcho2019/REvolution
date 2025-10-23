module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Sensor edge detection registers
    reg [2:0] s_prev;
    wire [2:0] s_rise = ~s_prev & s;
    wire [2:0] s_fall = s_prev & ~s;

    // Trend history (2 bits: 00=steady, 01=rising, 10=falling)
    reg [1:0] trend;

    // Current level state (encoded one-hot)
    reg [3:0] level_state;  // [3]=above s2, [2]=s2-s1, [1]=s1-s0, [0]=below s0

    always @(posedge clk) begin
        if (reset) begin
            s_prev <= 3'b000;
            trend <= 2'b00;
            level_state <= 4'b0001;  // Start below s0
        end else begin
            s_prev <= s;
            
            // Update trend history
            if (|s_rise) trend <= {1'b0, 1'b1};  // Rising
            else if (|s_fall) trend <= {1'b1, 1'b0};  // Falling
            else if (s != s_prev) trend <= 2'b00;  // Changed but no clear edge
            
            // Update level state
            case (s)
                3'b111: level_state <= 4'b1000;  // Above s2
                3'b011: level_state <= 4'b0100;  // Between s2-s1
                3'b001: level_state <= 4'b0010;  // Between s1-s0
                3'b000: level_state <= 4'b0001;  // Below s0
                default: level_state <= 4'b0000;  // Invalid (hold)
            endcase
        end
    end

    // Output logic
    assign fr0 = (level_state[3]) ? 1'b0 :  // Above s2
                 (level_state[2:0] != 3'b000);  // Any other level

    assign fr1 = (level_state[1] | level_state[0]);  // s1-s0 or below

    assign fr2 = level_state[0];  // Below s0 only

    // Supplemental flow when rising or recovering from low level
    assign dfr = (trend == 2'b01) ||  // Currently rising
                 (level_state[0] && (s != 3'b000));  // Just above bottom

endmodule