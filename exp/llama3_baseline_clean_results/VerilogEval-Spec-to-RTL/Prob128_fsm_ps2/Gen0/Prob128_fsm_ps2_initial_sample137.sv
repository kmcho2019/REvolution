module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

// Define states
typedef enum logic [1:0] {
    IDLE,
    BYTE_1,
    BYTE_2,
    BYTE_3
} state_t;

// State register
state_t state;

// Output signal
assign done = (state == BYTE_3);

// Main logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (in[3]) begin
                    state <= BYTE_1;
                end
            end
            BYTE_1: begin
                state <= BYTE_2;
            end
            BYTE_2: begin
                state <= BYTE_3;
            end
            BYTE_3: begin
                if (in[3]) begin
                    state <= BYTE_1;
                end else begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule