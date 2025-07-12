module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

// Define the states of the FSM
enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2,
    DONE
} state, next_state;

// Define the registers to store the received bytes
logic [7:0] byte1, byte2, byte3;

// Define the register to store the 24-bit message
logic [23:0] message;

// Define the combinational logic for the FSM
always_comb begin
    next_state = state;
    done = 1'b0;
    case (state)
        IDLE: begin
            if (in[3] == 1'b1) begin
                next_state = BYTE1;
                byte1 = in;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
            byte2 = in;
        end
        BYTE2: begin
            next_state = DONE;
            byte3 = in;
        end
        DONE: begin
            done = 1'b1;
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Define the sequential logic for the FSM
always_ff @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= IDLE;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
        message <= 24'b0;
    end else begin
        state <= next_state;
        if (next_state == DONE) begin
            message <= {byte1, byte2, byte3};
        end
    end
end

// Assign the output signals
assign out_bytes = message;
assign done = (state == DONE)? 1'b1 : 1'b0;

endmodule