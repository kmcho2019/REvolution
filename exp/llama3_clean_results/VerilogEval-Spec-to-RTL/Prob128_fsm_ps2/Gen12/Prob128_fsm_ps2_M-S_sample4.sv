module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM
enum logic [1:0] { IDLE, BYTE1, BYTE2 } state, next_state;

// State machine definition
always_comb begin
    next_state = state;
    case (state)
        IDLE: if (in[3]) next_state = BYTE1;
        BYTE1: next_state = BYTE2;
        BYTE2: next_state = IDLE;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Assert 'done' when a message is fully received
assign done = (state == BYTE2);

endmodule