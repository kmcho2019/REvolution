module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

// State machine states
enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2,
    BYTE3
} state, next_state;

// Registers to store input bytes
logic [7:0] byte1, byte2, byte3;

// Combinational logic to determine next state
always_comb begin
    case (state)
        IDLE: next_state = (in[3] == 1) ? BYTE1 : IDLE;
        BYTE1: next_state = BYTE2;
        BYTE2: next_state = BYTE3;
        BYTE3: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Sequential logic to update state and registers
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1) begin
                    byte1 <= in;
                    state <= BYTE1;
                end
            end
            BYTE1: begin
                byte2 <= in;
                state <= BYTE2;
            end
            BYTE2: begin
                byte3 <= in;
                state <= BYTE3;
            end
            BYTE3: begin
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

// Combinational logic to determine output
always_comb begin
    done = (state == BYTE3);
    if (done) begin
        out_bytes = {byte1, byte2, byte3};
    end else begin
        out_bytes = 24'b0;
    end
end

endmodule