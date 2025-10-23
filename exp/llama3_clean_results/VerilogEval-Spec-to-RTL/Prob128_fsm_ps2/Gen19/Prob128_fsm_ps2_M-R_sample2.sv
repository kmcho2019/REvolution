module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define the states
enum logic [1:0] {IDLE, RECEIVING_1, RECEIVING_2, RECEIVING_3} state, next_state;

// Use assign for combinational logic
assign next_state = (reset) ? IDLE :
                    (state == IDLE && in[3]) ? RECEIVING_1 :
                    (state == RECEIVING_1) ? RECEIVING_2 :
                    (state == RECEIVING_2) ? RECEIVING_3 :
                    (state == RECEIVING_3) ? IDLE :
                    state;

assign done = (state == RECEIVING_2); // Signal done when in RECEIVING_2 state

// Sequential logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule