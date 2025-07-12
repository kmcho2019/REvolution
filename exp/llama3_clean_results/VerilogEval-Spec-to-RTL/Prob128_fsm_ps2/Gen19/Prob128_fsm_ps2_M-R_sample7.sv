module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM using one-hot encoding
logic [2:0] state, next_state;

// Initialize state
always_ff @(posedge clk) begin
    if(reset) begin
        state <= 3'b001; // Reset to SEARCH state
    end
    else begin
        state <= next_state;
    end
end

// Combinational logic for next state
assign next_state = (state == 3'b001 && in[3]) ? 3'b010 : 
                    (state == 3'b010) ? 3'b100 : 
                    (state == 3'b100) ? 3'b001 : 3'b001;

// Assert 'done' when a message is fully received
assign done = (state == 3'b100);

endmodule