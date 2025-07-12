module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM using one-hot encoding
logic [2:0] state, next_state;

// Signal to indicate when a message is fully received
logic msg_received;

// Assign next state and msg_received based on current state and input
assign next_state = (state == 3'b001 && in[3] == 0) ? 3'b010 :
                     (state == 3'b001 && in[3] == 1) ? 3'b001 :
                     (state == 3'b010) ? 3'b100 :
                     (state == 3'b100) ? 3'b001 :
                     (in[3] == 1) ? 3'b001 : 3'b001;

assign msg_received = (state == 3'b100);

// Sequential logic to update state
always_ff @(posedge clk) begin
    if(reset) begin
        state <= 3'b001;
    end
    else begin
        state <= next_state;
    end
end

// Assert 'done' when a message is fully received
assign done = msg_received;

endmodule