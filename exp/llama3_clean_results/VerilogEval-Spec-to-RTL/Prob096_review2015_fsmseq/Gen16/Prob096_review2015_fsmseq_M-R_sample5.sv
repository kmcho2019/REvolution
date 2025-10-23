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

// Combinational logic for next state using assign
reg [2:0] next_state;
assign next_state = (state == IDLE && data)? STATE_1 :
                    (state == STATE_1 && data)? STATE_11 :
                    (state == STATE_11 && ~data)? STATE_110 :
                    (state == STATE_110 && data)? STATE_1101 :
                    (state == STATE_1101)? STATE_1101 : IDLE;

// Synchronous reset and state update
always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
    end
end

// Directly assign start_shifting based on the current state
always @(*) begin
    start_shifting = (state == STATE_1101);
end

endmodule