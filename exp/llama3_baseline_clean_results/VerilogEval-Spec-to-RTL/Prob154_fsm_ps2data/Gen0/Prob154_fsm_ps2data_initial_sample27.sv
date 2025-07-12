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

// Define the out_bytes register
logic [23:0] out_bytes_reg, out_bytes_next;

// Define the done signal
logic done_reg, done_next;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_bytes_reg <= 24'd0;
        done_reg <= 1'b0;
    end else begin
        state <= next_state;
        out_bytes_reg <= out_bytes_next;
        done_reg <= done_next;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    out_bytes_next = out_bytes_reg;
    done_next = 1'b0;

    case (state)
        IDLE: begin
            if (in[3]) begin
                out_bytes_next[7:0] = in;
                next_state = BYTE1;
            end
        end
        BYTE1: begin
            out_bytes_next[15:8] = in;
            next_state = BYTE2;
        end
        BYTE2: begin
            out_bytes_next[23:16] = in;
            next_state = DONE;
        end
        DONE: begin
            done_next = 1'b1;
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

// Output logic
assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule