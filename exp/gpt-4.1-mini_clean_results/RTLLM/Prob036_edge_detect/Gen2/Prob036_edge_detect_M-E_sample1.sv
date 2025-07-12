module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    typedef enum logic [0:0] {
        LOW_STATE  = 1'b0,
        HIGH_STATE = 1'b1
    } state_t;

    state_t current_state, next_state;

    // State update and edge output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= LOW_STATE;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            current_state <= next_state;
            rise <= 1'b0; // Default to zero, will be set if edge occurs
            down <= 1'b0;
            case (current_state)
                LOW_STATE: begin
                    if (a == 1'b1) begin
                        rise <= 1'b1;      // Rising edge detected
                        // next_state will be HIGH_STATE
                    end
                end
                HIGH_STATE: begin
                    if (a == 1'b0) begin
                        down <= 1'b1;      // Falling edge detected
                        // next_state will be LOW_STATE
                    end
                end
            endcase
        end
    end

    // Combinational logic to determine next state based on input 'a'
    always @(*) begin
        case (current_state)
            LOW_STATE:  next_state = (a == 1'b1) ? HIGH_STATE : LOW_STATE;
            HIGH_STATE: next_state = (a == 1'b0) ? LOW_STATE : HIGH_STATE;
            default:    next_state = LOW_STATE;
        endcase
    end

endmodule