module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

// State machine to keep track of previous water level
reg [1:0] state;
reg [1:0] nextState;

// Decode input sensors
wire above_s2 = s[2];
wire between_s2_s1 = s[1] && !s[2];
wire between_s1_s0 = s[0] && !s[1] && !s[2];
wire below_s0 = !s[0] && !s[1] && !s[2];

// Determine next state based on current state and sensors
always_comb begin
    case (state)
        2'b00: // below s0
            if (below_s0) nextState = 2'b00;
            else if (between_s1_s0) nextState = 2'b01;
            else if (between_s2_s1) nextState = 2'b10;
            else if (above_s2) nextState = 2'b11;
        2'b01: // between s1 and s0
            if (below_s0) nextState = 2'b00;
            else if (between_s1_s0) nextState = 2'b01;
            else if (between_s2_s1) nextState = 2'b10;
            else if (above_s2) nextState = 2'b11;
        2'b10: // between s2 and s1
            if (below_s0) nextState = 2'b00;
            else if (between_s1_s0) nextState = 2'b01;
            else if (between_s2_s1) nextState = 2'b10;
            else if (above_s2) nextState = 2'b11;
        2'b11: // above s2
            if (above_s2) nextState = 2'b11;
            else if (between_s2_s1) nextState = 2'b10;
            else if (between_s1_s0) nextState = 2'b01;
            else if (below_s0) nextState = 2'b00;
    endcase
end

// Update state on clock edge
always @(posedge clk) begin
    if (reset) state <= 2'b00; // reset to state corresponding to lowest water level
    else state <= nextState;
end

// Determine flow rate based on current state
always_comb begin
    case (state)
        2'b00: begin // below s0
            fr2 = 1'b1;
            fr1 = 1'b1;
            fr0 = 1'b1;
        end
        2'b01: begin // between s1 and s0
            fr2 = 1'b0;
            fr1 = 1'b1;
            fr0 = 1'b1;
        end
        2'b10: begin // between s2 and s1
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b1;
        end
        2'b11: begin // above s2
            fr2 = 1'b0;
            fr1 = 1'b0;
            fr0 = 1'b0;
        end
    endcase
end

// Determine whether to open supplemental flow valve (dfr)
always_comb begin
    if (state == 2'b00 && (between_s1_s0 || between_s2_s1 || above_s2)) dfr = 1'b1; // previous level was lower than current level
    else if (state == 2'b01 && (between_s2_s1 || above_s2)) dfr = 1'b1;
    else if (state == 2'b10 && above_s2) dfr = 1'b1;
    else dfr = 1'b0;
end

endmodule