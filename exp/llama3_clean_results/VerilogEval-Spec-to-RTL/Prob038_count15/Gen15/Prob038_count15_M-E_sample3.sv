module TopModule(
    input clk, // Clock signal
    input reset, // Active high synchronous reset
    output reg [3:0] q // 4-bit counter output
);

// Define the states for the FSM
reg [3:0] state; // Current state of the FSM
reg [3:0] nextState; // Next state of the FSM

// State transition logic
always @(*) begin
    case (state)
        4'd0: nextState = (reset)? 4'd0 : 4'd1;
        4'd1: nextState = (reset)? 4'd0 : 4'd2;
        4'd2: nextState = (reset)? 4'd0 : 4'd3;
        4'd3: nextState = (reset)? 4'd0 : 4'd4;
        4'd4: nextState = (reset)? 4'd0 : 4'd5;
        4'd5: nextState = (reset)? 4'd0 : 4'd6;
        4'd6: nextState = (reset)? 4'd0 : 4'd7;
        4'd7: nextState = (reset)? 4'd0 : 4'd8;
        4'd8: nextState = (reset)? 4'd0 : 4'd9;
        4'd9: nextState = (reset)? 4'd0 : 4'd10;
        4'd10: nextState = (reset)? 4'd0 : 4'd11;
        4'd11: nextState = (reset)? 4'd0 : 4'd12;
        4'd12: nextState = (reset)? 4'd0 : 4'd13;
        4'd13: nextState = (reset)? 4'd0 : 4'd14;
        4'd14: nextState = (reset)? 4'd0 : 4'd15;
        4'd15: nextState = (reset)? 4'd0 : 4'd0;
        default: nextState = (reset)? 4'd0 : 4'd0;
    endcase
end

// Sequential logic to update the state on the positive clock edge
always @(posedge clk) begin
    state <= nextState;
    q <= state;
end

// Initialize the state
initial begin
    state = 4'd0;
end

endmodule