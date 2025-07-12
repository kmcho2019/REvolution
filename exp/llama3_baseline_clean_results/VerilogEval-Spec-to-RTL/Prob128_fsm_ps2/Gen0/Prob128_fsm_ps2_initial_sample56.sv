module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

// Define the states
enum logic [1:0] {
    IDLE = 2'b00,
    BYTE_1 = 2'b01,
    BYTE_2 = 2'b10,
    BYTE_3 = 2'b11
} state, next_state;

// Current state register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (in[3] == 1'b1) begin
                next_state = BYTE_1;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE_1: next_state = BYTE_2;
        BYTE_2: next_state = BYTE_3;
        BYTE_3: begin
            if (reset) begin
                next_state = IDLE;
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Output logic
assign done = (state == BYTE_3);

endmodule