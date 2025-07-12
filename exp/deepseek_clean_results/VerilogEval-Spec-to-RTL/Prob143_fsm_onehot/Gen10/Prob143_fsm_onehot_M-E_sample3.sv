module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

// Priority encoder to select the highest priority active state
wire [3:0] current_state_num;
assign current_state_num = 
    state[9] ? 4'd9 :
    state[8] ? 4'd8 :
    state[7] ? 4'd7 :
    state[6] ? 4'd6 :
    state[5] ? 4'd5 :
    state[4] ? 4'd4 :
    state[3] ? 4'd3 :
    state[2] ? 4'd2 :
    state[1] ? 4'd1 : 4'd0;

always @(*) begin
    // Default outputs
    out1 = 1'b0;
    out2 = 1'b0;
    next_state = 10'b0;
    
    // State transition and output logic
    case (current_state_num)
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
            out2 = 1'b1;
        end
        4'd8: begin // S8
            next_state[0] = ~in;
            next_state[1] = in;
            out1 = 1'b1;
        end
        4'd9: begin // S9
            next_state[0] = ~in;
            next_state[1] = in;
            out1 = 1'b1;
            out2 = 1'b1;
        end
        default: begin
            next_state[0] = 1'b1; // Default to S0
        end
    endcase
end

endmodule