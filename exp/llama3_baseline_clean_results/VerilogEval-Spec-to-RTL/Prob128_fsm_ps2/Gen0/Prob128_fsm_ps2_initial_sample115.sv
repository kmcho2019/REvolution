module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

// Define the states of the FSM
enum logic [1:0] {IDLE, BYTE1, BYTE2, BYTE3} state, next_state;

// Output signal
logic done_reg;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 1'b0;
    end else begin
        state <= next_state;
        done_reg <= 1'b0;
        if (next_state == BYTE3) begin
            done_reg <= 1'b1;
        end
    end
end

// Combinational logic
always_comb begin
    next_state = state;
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
            next_state = BYTE3;
        end
        BYTE3: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Assign output signal
assign done = done_reg;

endmodule