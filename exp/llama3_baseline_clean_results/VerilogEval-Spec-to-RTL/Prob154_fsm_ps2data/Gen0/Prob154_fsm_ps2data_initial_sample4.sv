module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

// Define the states of the FSM
typedef enum logic [1:0] {
    IDLE = 2'b00,
    BYTE1 = 2'b01,
    BYTE2 = 2'b10,
    DONESTATE = 2'b11
} state_t;

// Current state and next state
state_t current_state, next_state;

// Register to store the received bytes
reg [23:0] bytes;

// Output signals
assign done = (current_state == DONESTATE);
assign out_bytes = bytes;

// State machine
always_comb begin
    case(current_state)
        IDLE: begin
            if(in[3] == 1'b1) begin
                bytes[23:16] = in;
                next_state = BYTE1;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE1: begin
            bytes[15:8] = in;
            next_state = BYTE2;
        end
        BYTE2: begin
            bytes[7:0] = in;
            next_state = DONESTATE;
        end
        DONESTATE: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if(reset) begin
        current_state <= IDLE;
        bytes <= 24'b0;
    end else begin
        current_state <= next_state;
    end
end

endmodule