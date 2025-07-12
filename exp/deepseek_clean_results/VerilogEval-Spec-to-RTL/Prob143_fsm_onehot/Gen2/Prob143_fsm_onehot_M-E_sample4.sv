module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output reg out1,
    output reg out2
);

    wire [3:0] highest_state;
    reg [3:0] next_state_num;
    
    // Priority encoder to find highest active state
    assign highest_state = 
        state[9] ? 4'd9 :
        state[8] ? 4'd8 :
        state[7] ? 4'd7 :
        state[6] ? 4'd6 :
        state[5] ? 4'd5 :
        state[4] ? 4'd4 :
        state[3] ? 4'd3 :
        state[2] ? 4'd2 :
        state[1] ? 4'd1 :
        4'd0;

    always @(*) begin
        // Default outputs
        out1 = 0;
        out2 = 0;
        next_state = 10'b0;
        next_state_num = 4'd0;
        
        // Handle state transitions
        case (highest_state)
            4'd0: next_state_num = in ? 4'd1 : 4'd0;  // S0
            4'd1: next_state_num = in ? 4'd2 : 4'd0;  // S1
            4'd2: next_state_num = in ? 4'd3 : 4'd0;  // S2
            4'd3: next_state_num = in ? 4'd4 : 4'd0;  // S3
            4'd4: next_state_num = in ? 4'd5 : 4'd0;  // S4
            4'd5: next_state_num = in ? 4'd6 : 4'd8;  // S5
            4'd6: next_state_num = in ? 4'd7 : 4'd9;  // S6
            4'd7: begin                               // S7
                out2 = 1;
                next_state_num = in ? 4'd7 : 4'd0;
            end
            4'd8: begin                               // S8
                out1 = 1;
                next_state_num = in ? 4'd1 : 4'd0;
            end
            4'd9: begin                               // S9
                out1 = 1;
                out2 = 1;
                next_state_num = in ? 4'd1 : 4'd0;
            end
            default: next_state_num = 4'd0;
        endcase
        
        // Convert state number back to one-hot
        next_state[next_state_num] = 1'b1;
    end

endmodule