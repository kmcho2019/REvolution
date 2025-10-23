module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output       done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE   = 2'd0,
        BYTE_1 = 2'd1,
        BYTE_2 = 2'd2,
        BYTE_3 = 2'd3
    } state_t;

    state_t state, next_state;

    // Registers to hold the three bytes
    reg [7:0] byte1, byte2, byte3;

    // Sequential logic for state and data registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'd0;
            byte2 <= 8'd0;
            byte3 <= 8'd0;
        end else begin
            state <= next_state;
            // Capture bytes on transitions, controlled below
            case (next_state)
                BYTE_1: byte1 <= in;
                BYTE_2: byte2 <= in;
                BYTE_3: byte3 <= in;
                default: begin
                    // No change to bytes
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold
        case(state)
            IDLE: 
                if (in[3]) 
                    next_state = BYTE_1;
            BYTE_1:
                next_state = BYTE_2;
            BYTE_2:
                next_state = BYTE_3;
            BYTE_3:
                next_state = IDLE;
            default:
                next_state = IDLE;
        endcase
    end

    // Output assignments (Mealy style)
    assign out_bytes = {byte1, byte2, byte3};
    assign done = (state == BYTE_3);

endmodule