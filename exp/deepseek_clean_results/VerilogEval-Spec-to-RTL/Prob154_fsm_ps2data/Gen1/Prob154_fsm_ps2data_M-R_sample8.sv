module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        BYTE1,
        BYTE2
    } state_t;

    // State and data registers
    state_t state, next_state;
    reg [7:0] byte1, byte2, byte3;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte1 <= 8'b0;
            byte2 <= 8'b0;
            byte3 <= 8'b0;
        end else begin
            state <= next_state;
            
            // Store bytes as they arrive
            case (state)
                IDLE: if (in[3]) byte1 <= in;
                BYTE1: byte2 <= in;
                BYTE2: byte3 <= in;
            endcase
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: next_state = (in[3]) ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output assignments
    assign out_bytes = (state == BYTE2) ? {byte1, byte2, in} : 24'b0;
    assign done = (state == BYTE2);

endmodule