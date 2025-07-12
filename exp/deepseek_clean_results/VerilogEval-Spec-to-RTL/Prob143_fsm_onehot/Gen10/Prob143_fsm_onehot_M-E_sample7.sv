module TopModule (
    input in,
    input [9:0] state,
    output reg [9:0] next_state,
    output out1,
    output out2
);

// Priority encoder to find highest active state
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

// Output logic based on state range
assign out1 = (current_state_num == 4'd8) || (current_state_num == 4'd9);
assign out2 = (current_state_num == 4'd7) || (current_state_num == 4'd9);

always @(*) begin
    next_state = 10'b0;
    
    if (in) begin
        // Handle increment cases for S0-S4 and S8-S9
        if (current_state_num <= 4'd4 || current_state_num >= 4'd8) begin
            if (current_state_num < 4'd9) begin
                next_state[current_state_num + 1] = 1'b1;
            end
        end
        // Special cases for S5-S7
        else begin
            case (current_state_num)
                4'd5: next_state[6] = 1'b1;
                4'd6: next_state[7] = 1'b1;
                4'd7: next_state[7] = 1'b1;
            endcase
        end
    end
    else begin
        // Most states reset to S0 on 0
        if (current_state_num != 4'd7) begin  // S7 doesn't reset on 0
            next_state[0] = 1'b1;
        end
        // Special cases for S5 and S6
        case (current_state_num)
            4'd5: next_state[8] = 1'b1;
            4'd6: next_state[9] = 1'b1;
        endcase
    end
end

endmodule