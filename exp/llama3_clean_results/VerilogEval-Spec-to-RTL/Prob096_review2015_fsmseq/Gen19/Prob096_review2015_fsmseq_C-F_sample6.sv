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
localparam STATE_110 = 2'b11;

// Initialize the FSM to the IDLE state
initial state = IDLE;

// Combinational logic for next state
reg [1:0] next_state;
always @(*) begin
    case(state)
        IDLE: next_state = data? STATE_1 : IDLE;
        STATE_1: next_state = data? STATE_11 : IDLE;
        STATE_11: next_state = ~data? STATE_110 : STATE_11;
        STATE_110: next_state = data? STATE_110 : IDLE;
        default: next_state = IDLE;
    endcase
end

// Synchronous reset and state update
reg seq_detected;
always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        seq_detected <= 0;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if(next_state == STATE_110 && data) begin
            seq_detected <= 1;
        end
        start_shifting <= seq_detected;
    end
end

endmodule