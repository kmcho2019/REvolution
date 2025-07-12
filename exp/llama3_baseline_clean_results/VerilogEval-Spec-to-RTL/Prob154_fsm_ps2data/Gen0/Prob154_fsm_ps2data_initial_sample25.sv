module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

// Define the states
enum logic [1:0] {
    IDLE,
    BYTE1,
    BYTE2,
    DONE
} state, next_state;

// Define the registers
logic [7:0] byte1, byte2, byte3;
logic [23:0] out_bytes_reg;

// FSM logic
always_comb begin
    next_state = state;
    done = 1'b0;
    case(state)
        IDLE: begin
            if (in[3] == 1'b1) begin
                byte1 = in;
                next_state = BYTE1;
            end
        end
        BYTE1: begin
            byte2 = in;
            next_state = BYTE2;
        end
        BYTE2: begin
            byte3 = in;
            next_state = DONE;
        end
        DONE: begin
            done = 1'b1;
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Datapath logic
always_comb begin
    out_bytes = out_bytes_reg;
    if (state == DONE) begin
        out_bytes_reg = {byte1, byte2, byte3};
    end
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule