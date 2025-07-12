module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Priority encoder to find highest priority active state
wire [3:0] active_state;
assign active_state = 
    state[0] ? 4'd0 :
    state[1] ? 4'd1 :
    state[2] ? 4'd2 :
    state[3] ? 4'd3 :
    state[4] ? 4'd4 :
    state[5] ? 4'd5 :
    state[6] ? 4'd6 :
    state[7] ? 4'd7 :
    state[8] ? 4'd8 :
    state[9] ? 4'd9 : 4'd0;

// Output pre-calculation
wire next_out1, next_out2;
assign next_out1 = (active_state == 4'd8) | (active_state == 4'd9);
assign next_out2 = (active_state == 4'd7) | (active_state == 4'd9);

assign out1 = next_out1;
assign out2 = next_out2;

// State transition logic
always @(*) begin
    next_state = 10'b0;
    
    case (active_state)
        4'd0: begin // S0
            next_state[0] = ~in;
            next_state[1] = in;
        end
        4'd1: begin // S1
            next_state[0] = ~in;
            next_state[2] = in;
        end
        4'd2: begin // S2
            next_state[0] = ~in;
            next_state[3] = in;
        end
        4'd3: begin // S3
            next_state[0] = ~in;
            next_state[4] = in;
        end
        4'd4: begin // S4
            next_state[0] = ~in;
            next_state[5] = in;
        end
        4'd5: begin // S5
            next_state[8] = ~in;
            next_state[6] = in;
        end
        4'd6: begin // S6
            next_state[9] = ~in;
            next_state[7] = in;
        end
        4'd7: begin // S7
            next_state[0] = ~in;
            next_state[7] = in;
        end
        4'd8: begin // S8
            next_state[0] = ~in;
            next_state[1] = in;
        end
        4'd9: begin // S9
            next_state[0] = ~in;
            next_state[1] = in;
        end
        default: next_state[0] = 1'b1; // Default to S0
    endcase
end

endmodule