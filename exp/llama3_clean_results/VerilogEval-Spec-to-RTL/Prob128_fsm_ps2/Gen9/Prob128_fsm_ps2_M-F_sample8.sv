module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states
enum logic [1:0] {
    IDLE,
    BYTE_1,
    BYTE_2,
    BYTE_3
} state, next_state;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Signal to indicate that we've received the third byte
logic third_byte_received;
always_ff @(posedge clk) begin
    if (reset) begin
        third_byte_received <= 0;
    end else if (state == BYTE_2 && next_state == BYTE_3) begin
        third_byte_received <= 1;
    end else if (state == BYTE_3 && next_state == IDLE) begin
        third_byte_received <= 0;
    end else begin
        third_byte_received <= third_byte_received;
    end
end

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (in[3]) begin
                next_state = BYTE_1;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE_1: next_state = BYTE_2;
        BYTE_2: next_state = BYTE_3;
        BYTE_3: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Done signal generation
assign done = (state == BYTE_3) && third_byte_received;

endmodule