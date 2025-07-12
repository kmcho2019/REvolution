module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM using one-hot encoding
logic [2:0] state, next_state;

// Signal to indicate when a message is fully received
logic msg_received, next_msg_received;

// State machine definition
assign next_state = (reset)? 1'b001 : 
                    (state == 1'b001 && in[3])? 1'b010 : 
                    (state == 1'b010)? 1'b100 : 
                    (state == 1'b100)? 1'b001 : state;

assign next_msg_received = (state == 1'b100)? 1'b1 : 1'b0;

// Sequential logic
always_ff @(posedge clk) begin
    if(reset) begin
        state <= 1'b001;
        msg_received <= 0;
    end
    else begin
        state <= next_state;
        msg_received <= next_msg_received;
    end
end

// Assert 'done' when a message is fully received
assign done = msg_received;

endmodule