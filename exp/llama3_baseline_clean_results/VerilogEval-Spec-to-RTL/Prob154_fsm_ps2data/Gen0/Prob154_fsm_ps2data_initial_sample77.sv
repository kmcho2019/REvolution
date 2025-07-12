module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

// Define the states of the FSM
enum logic [1:0] {IDLE, BYTE1, BYTE2, BYTE3} state, next_state;

// Define the 24-bit register to store the message
logic [23:0] message;

// Define the counter to keep track of the current byte
logic [1:0] byte_count;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        message <= 24'd0;
        byte_count <= 2'd0;
    end else begin
        state <= next_state;
        if (state == IDLE && in[3]) begin
            message[7:0] <= in;
            byte_count <= 1;
        end else if (state == BYTE1) begin
            message[15:8] <= in;
            byte_count <= 2;
        end else if (state == BYTE2) begin
            message[23:16] <= in;
            byte_count <= 3;
        end
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (in[3]) begin
                next_state = BYTE1;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
        end
        BYTE2: begin
            next_state = BYTE3;
        end
        BYTE3: begin
            next_state = IDLE;
        end
    endcase
end

// Output logic
assign done = (state == BYTE3);
assign out_bytes = message;

endmodule