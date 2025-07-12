module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// Define the states of the FSM
localparam [3:0] STATE_0 = 4'd0;
localparam [3:0] STATE_1 = 4'd1;
localparam [3:0] STATE_2 = 4'd2;
localparam [3:0] STATE_3 = 4'd3;
localparam [3:0] STATE_4 = 4'd4;
localparam [3:0] STATE_5 = 4'd5;
localparam [3:0] STATE_6 = 4'd6;
localparam [3:0] STATE_7 = 4'd7;
localparam [3:0] STATE_8 = 4'd8;
localparam [3:0] STATE_9 = 4'd9;
localparam [3:0] STATE_10 = 4'd10;
localparam [3:0] STATE_11 = 4'd11;
localparam [3:0] STATE_12 = 4'd12;
localparam [3:0] STATE_13 = 4'd13;
localparam [3:0] STATE_14 = 4'd14;
localparam [3:0] STATE_15 = 4'd15;

// Initialize the current state
reg [3:0] current_state;

// Define the next state logic
always @(posedge clk) begin
    if (reset) begin
        // Reset to STATE_0
        current_state <= STATE_0;
    end else begin
        case (current_state)
            STATE_0: current_state <= STATE_1;
            STATE_1: current_state <= STATE_2;
            STATE_2: current_state <= STATE_3;
            STATE_3: current_state <= STATE_4;
            STATE_4: current_state <= STATE_5;
            STATE_5: current_state <= STATE_6;
            STATE_6: current_state <= STATE_7;
            STATE_7: current_state <= STATE_8;
            STATE_8: current_state <= STATE_9;
            STATE_9: current_state <= STATE_10;
            STATE_10: current_state <= STATE_11;
            STATE_11: current_state <= STATE_12;
            STATE_12: current_state <= STATE_13;
            STATE_13: current_state <= STATE_14;
            STATE_14: current_state <= STATE_15;
            STATE_15: current_state <= STATE_0;
            default: current_state <= STATE_0; // This should never occur
        endcase
    end
end

// Assign the output
assign q = current_state;

endmodule