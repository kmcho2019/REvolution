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

// Define the registers to store the bytes of the message
logic [7:0] byte1, byte2, byte3;

// Define the combinational logic for the next state
always_comb begin
    next_state = state;
    done = 1'b0;
    case (state)
        IDLE: begin
            if (in[3] == 1'b1) begin
                next_state = BYTE1;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
        end
        BYTE2: begin
            next_state = DONE;
        end
        DONE: begin
            done = 1'b1;
            if (in[3] == 1'b1) begin
                next_state = BYTE1;
            end else begin
                next_state = IDLE;
            end
        end
    endcase
end

// Define the sequential logic for the state registers
always_ff @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= IDLE;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                // Do nothing
            end
            BYTE1: begin
                byte1 <= in;
            end
            BYTE2: begin
                byte2 <= in;
            end
            DONE: begin
                byte3 <= in;
            end
        endcase
    end
end

// Define the output logic for out_bytes
assign out_bytes = {byte1, byte2, byte3};

endmodule