module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// Enumerate states
typedef enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2
} state_t;

// State register
state_t state, next_state;

// Message bytes
reg [7:0] byte1, byte2, byte3;

// Default values
always_comb begin
    next_state = state;
    done = 1'b0;
end

// State transitions and datapath
always_comb begin
    case (state)
        IDLE: begin
            if (~reset && in[3]) begin
                byte1 = in;
                next_state = BYTE1;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE1: begin
            byte2 = in;
            next_state = BYTE2;
        end
        BYTE2: begin
            byte3 = in;
            out_bytes = {byte1, byte2, byte3};
            done = 1'b1;
            next_state = IDLE;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_bytes <= 24'd0;
        done <= 1'b0;
    end else begin
        state <= next_state;
    end
end

endmodule