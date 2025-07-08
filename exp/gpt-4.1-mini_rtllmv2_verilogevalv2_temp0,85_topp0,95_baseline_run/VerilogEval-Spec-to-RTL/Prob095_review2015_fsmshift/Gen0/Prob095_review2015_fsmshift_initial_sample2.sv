module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  shift_ena
);

    typedef enum logic [0:0] {
        IDLE   = 1'b0,
        ENABLE = 1'b1
    } state_t;

    state_t state, next_state;
    reg [1:0] count; // 2-bit counter for 4 cycles

    // Next state logic and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            count <= 2'b00;
            shift_ena <= 1'b1;
        end else begin
            state <= next_state;
            case (state)
                ENABLE: begin
                    if (count == 2'b11) begin
                        shift_ena <= 1'b0;
                        count <= count; // hold count
                    end else begin
                        count <= count + 1;
                        shift_ena <= 1'b1;
                    end
                end
                IDLE: begin
                    shift_ena <= 1'b0;
                    count <= 2'b00;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            ENABLE: begin
                if (count == 2'b11)
                    next_state = IDLE;
                else
                    next_state = ENABLE;
            end
            IDLE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule