module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states for each prefix of the target sequence
reg [2:0] state;
localparam IDLE = 3'b000;
localparam STATE_1 = 3'b001;
localparam STATE_11 = 3'b010;
localparam STATE_110 = 3'b011;
localparam STATE_1101 = 3'b100;

// Initialize the FSM to the IDLE state
initial state = IDLE;

// Combinational logic for next state
always @(*) begin
    case(state)
        IDLE: state = data ? STATE_1 : IDLE;
        STATE_1: state = data ? STATE_11 : IDLE;
        STATE_11: state = ~data ? STATE_110 : STATE_11;
        STATE_110: state = data ? STATE_1101 : IDLE;
        STATE_1101: state = STATE_1101; // Remain in this state once reached
        default: state = IDLE;
    endcase
end

// Synchronous reset and state update
always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        start_shifting <= (state == STATE_1101) ? 1 : ((state != STATE_1101) && start_shifting) ? start_shifting : 0;
    end
end

endmodule