module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// Define states for the FSM
logic [1:0] state;

// Directly drive next_state and done signals using assign statements
logic [1:0] next_state;
assign next_state = (state == 2'd0 && in[3]) ? 2'd1 :
                     (state == 2'd1) ? 2'd2 :
                     (state == 2'd2) ? 2'd0 : state;

assign done = (state == 2'd2);

// Sequential logic for state update and reset
always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'd0;
    end
    else begin
        state <= next_state;
    end
end

endmodule