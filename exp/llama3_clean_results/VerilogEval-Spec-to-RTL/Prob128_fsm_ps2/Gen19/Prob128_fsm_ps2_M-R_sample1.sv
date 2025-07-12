module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM using binary encoding
logic [1:0] state, next_state;

// Initialize state to SEARCH (0)
assign next_state = (reset)? 2'b00 : 
                     (state == 2'b00 && in[3])? 2'b01 : 
                     (state == 2'b01)? 2'b10 : 
                     (state == 2'b10)? 2'b00 : 2'b00;

// Assert 'done' when a message is fully received (state == 2'b10)
assign done = (state == 2'b10);

// Sequential logic for state register
always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'b00;
    end
    else begin
        state <= next_state;
    end
end

endmodule