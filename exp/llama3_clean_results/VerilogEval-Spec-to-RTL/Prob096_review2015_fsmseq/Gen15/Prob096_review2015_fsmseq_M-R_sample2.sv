module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states for each prefix of the target sequence
reg [1:0] state;
localparam IDLE = 2'b00;
localparam STATE_1 = 2'b01;
localparam STATE_11 = 2'b10;
localparam STATE_1101 = 2'b11;

// Initialize the FSM to the IDLE state
initial state = IDLE;

// Combinational logic for next state
reg [1:0] next_state;
assign next_state = (reset)? IDLE :
                    (state == IDLE)? (data? STATE_1 : IDLE) :
                    (state == STATE_1)? (data? STATE_11 : IDLE) :
                    (state == STATE_11)? (~data? STATE_1101 : STATE_11) :
                    (state == STATE_1101)? (data? STATE_1 : IDLE) : IDLE;

// Synchronous reset and state update
always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        start_shifting <= (state == STATE_1101 || start_shifting) &&!reset;
    end
end

endmodule