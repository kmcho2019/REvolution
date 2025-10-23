module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    // One-hot encoded states
    localparam [3:0] IDLE         = 4'b0001;
    localparam [3:0] RISE_DETECTED = 4'b0010;
    localparam [3:0] FALL_DETECTED = 4'b0100;
    localparam [3:0] STABLE       = 4'b1000;

    reg [3:0] current_state, next_state;
    reg a_prev;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            a_prev <= 1'b0;
        end else begin
            current_state <= next_state;
            a_prev <= a;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (a_prev && !a) next_state = FALL_DETECTED;
                else if (!a_prev && a) next_state = RISE_DETECTED;
                else next_state = IDLE;
            end
            RISE_DETECTED: next_state = STABLE;
            FALL_DETECTED: next_state = STABLE;
            STABLE: begin
                if (a_prev && !a) next_state = FALL_DETECTED;
                else if (!a_prev && a) next_state = RISE_DETECTED;
                else next_state = STABLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        rise = (current_state == RISE_DETECTED);
        down = (current_state == FALL_DETECTED);
    end

endmodule