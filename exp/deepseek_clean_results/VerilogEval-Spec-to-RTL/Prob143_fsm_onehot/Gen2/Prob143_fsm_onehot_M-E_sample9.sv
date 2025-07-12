module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

wire [3:0] priority_state;
reg [9:0] single_state;

// Priority encoder to select highest priority active state
assign priority_state = 
    state[9] ? 4'd9 :
    state[8] ? 4'd8 :
    state[7] ? 4'd7 :
    state[6] ? 4'd6 :
    state[5] ? 4'd5 :
    state[4] ? 4'd4 :
    state[3] ? 4'd3 :
    state[2] ? 4'd2 :
    state[1] ? 4'd1 :
    state[0] ? 4'd0 : 4'd0;

// Convert priority state back to one-hot for transition logic
always @(*) begin
    single_state = 10'b0;
    case (priority_state)
        4'd0: single_state[0] = 1'b1;
        4'd1: single_state[1] = 1'b1;
        4'd2: single_state[2] = 1'b1;
        4'd3: single_state[3] = 1'b1;
        4'd4: single_state[4] = 1'b1;
        4'd5: single_state[5] = 1'b1;
        4'd6: single_state[6] = 1'b1;
        4'd7: single_state[7] = 1'b1;
        4'd8: single_state[8] = 1'b1;
        4'd9: single_state[9] = 1'b1;
    endcase
end

// State transition logic based on priority state
always @(*) begin
    next_state = 10'b0;
    case (priority_state)
        // Counting states (S0-S4)
        4'd0: next_state = in ? 10'b0000000010 : 10'b0000000001;
        4'd1: next_state = in ? 10'b0000000100 : 10'b0000000001;
        4'd2: next_state = in ? 10'b0000001000 : 10'b0000000001;
        4'd3: next_state = in ? 10'b0000010000 : 10'b0000000001;
        4'd4: next_state = in ? 10'b0000100000 : 10'b0000000001;
        // Special counting states (S5-S6)
        4'd5: next_state = in ? 10'b0001000000 : 10'b0100000000;
        4'd6: next_state = in ? 10'b0010000000 : 10'b1000000000;
        // Terminal states (S7-S9)
        4'd7: next_state = in ? 10'b0010000000 : 10'b0000000001;
        4'd8: next_state = in ? 10'b0000000010 : 10'b0000000001;
        4'd9: next_state = in ? 10'b0000000010 : 10'b0000000001;
        default: next_state = 10'b0000000001;
    endcase
end

// Output logic - simple pattern matching
always @(*) begin
    out1 = (state[8] | state[9]);
    out2 = (state[7] | state[9]);
end

endmodule