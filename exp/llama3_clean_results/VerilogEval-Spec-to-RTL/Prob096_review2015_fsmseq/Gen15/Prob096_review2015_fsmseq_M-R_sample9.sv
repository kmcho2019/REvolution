module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] state;

// Initialize the FSM to the IDLE state
initial state ='b0000;

// Combinational logic for next state
wire [3:0] next_state;
assign next_state = (state == 4'b0000 && data) ? 4'b0001 :
                     (state == 4'b0001 && data) ? 4'b0010 :
                     (state == 4'b0010 && ~data) ? 4'b0011 :
                     (state == 4'b0011 && data) ? 4'b0100 :
                     (state == 4'b0100) ? 4'b0100 :
                     4'b0000;

// Synchronous reset and state update
always @(posedge clk) begin
    if(reset) begin
        state <= 4'b0000;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if(next_state == 4'b0100) begin
            start_shifting <= 1;
        end else if(state != 4'b0100) begin
            start_shifting <= 0;
        end
    end
end

endmodule