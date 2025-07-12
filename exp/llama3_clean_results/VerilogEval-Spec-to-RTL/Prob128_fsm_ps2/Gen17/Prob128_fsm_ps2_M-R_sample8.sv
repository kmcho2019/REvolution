module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM (2-bit binary encoding)
logic [1:0] state, next_state;

// Signal to indicate when a message is fully received
logic msg_received;

// Combinational logic for next state
assign next_state = (state == 2'b00 && in[3]) ? 2'b01 :
                    (state == 2'b01) ? 2'b10 :
                    (state == 2'b10) ? 2'b00 : state;

// Sequential logic for state and msg_received
always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'b00;
        msg_received <= 0;
    end
    else begin
        state <= next_state;
        msg_received <= (state == 2'b10) ? 1 : 0;
    end
end

// Assert 'done' when a message is fully received
assign done = msg_received;

endmodule