module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Precompute input conditions
wire in_n = ~in;
wire in_p = in;

// Priority encoder for states S0-S6
wire [2:0] pri_state;
assign pri_state = 
    state[6] ? 3'd6 :
    state[5] ? 3'd5 :
    state[4] ? 3'd4 :
    state[3] ? 3'd3 :
    state[2] ? 3'd2 :
    state[1] ? 3'd1 :
    3'd0;  // S0

// Unified transition logic
always @(*) begin
    next_state = 10'b0;
    
    // Handle S0-S6 transitions
    case (pri_state)
        3'd0: begin // S0
            next_state[0] = in_n;
            next_state[1] = in_p;
        end
        3'd1: begin // S1
            next_state[0] = in_n;
            next_state[2] = in_p;
        end
        3'd2: begin // S2
            next_state[0] = in_n;
            next_state[3] = in_p;
        end
        3'd3: begin // S3
            next_state[0] = in_n;
            next_state[4] = in_p;
        end
        3'd4: begin // S4
            next_state[0] = in_n;
            next_state[5] = in_p;
        end
        3'd5: begin // S5
            next_state[8] = in_n;
            next_state[6] = in_p;
        end
        3'd6: begin // S6
            next_state[9] = in_n;
            next_state[7] = in_p;
        end
    endcase
    
    // Handle one-hot states S7-S9
    if (state[7]) begin
        next_state[0] = in_n;
        next_state[7] = in_p;
    end
    if (state[8]) begin
        next_state[0] = in_n;
        next_state[1] = in_p;
    end
    if (state[9]) begin
        next_state[0] = in_n;
        next_state[1] = in_p;
    end
end

// Shared output decoder
assign out1 = state[8] | state[9];
assign out2 = state[7] | state[9];

endmodule