module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// Define the states
enum logic [1:0] {IDLE, BYTE1, BYTE2, DONE} state, next_state;

// Registers to store the bytes
reg [7:0] byte1, byte2, byte3;

// Combinational logic to determine the next state
always_comb begin
    case (state)
        IDLE: begin
            if (in[3] == 1'b1)
                next_state = BYTE1;
            else
                next_state = IDLE;
        end
        BYTE1: next_state = BYTE2;
        BYTE2: next_state = DONE;
        DONE: next_state = IDLE;
    endcase
end

// Sequential logic to update the state and store the bytes
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
        byte3 <= 8'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1)
                    byte1 <= in;
            end
            BYTE1: byte2 <= in;
            BYTE2: byte3 <= in;
            DONE: begin
                out_bytes <= {byte1, byte2, byte3};
                done <= 1'b1;
            end
        endcase
        state <= next_state;
        if (state == DONE)
            done <= 1'b1;
        else
            done <= 1'b0;
    end
end

endmodule