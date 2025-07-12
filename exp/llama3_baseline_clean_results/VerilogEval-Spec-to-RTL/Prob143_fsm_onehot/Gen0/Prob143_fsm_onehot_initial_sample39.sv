module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

// Default assignment
assign next_state = 10'b0;
assign out1 = 1'b0;
assign out2 = 1'b0;

// Case statement for each state and input combination
always @(*)
begin
    case ({state, in})
        // S0
        {10'b0000000001, 1'b0}: next_state[0] = 1'b1;
        {10'b0000000001, 1'b1}: next_state[1] = 1'b1;
        
        // S1
        {10'b0000000010, 1'b0}: next_state[0] = 1'b1;
        {10'b0000000010, 1'b1}: next_state[2] = 1'b1;
        
        // S2
        {10'b0000000100, 1'b0}: next_state[0] = 1'b1;
        {10'b0000000100, 1'b1}: next_state[3] = 1'b1;
        
        // S3
        {10'b0000001000, 1'b0}: next_state[0] = 1'b1;
        {10'b0000001000, 1'b1}: next_state[4] = 1'b1;
        
        // S4
        {10'b0000010000, 1'b0}: next_state[0] = 1'b1;
        {10'b0000010000, 1'b1}: next_state[5] = 1'b1;
        
        // S5
        {10'b0000100000, 1'b0}: next_state[8] = 1'b1;
        {10'b0000100000, 1'b1}: next_state[6] = 1'b1;
        
        // S6
        {10'b0001000000, 1'b0}: next_state[9] = 1'b1;
        {10'b0001000000, 1'b1}: next_state[7] = 1'b1;
        
        // S7
        {10'b0010000000, 1'b0}: next_state[0] = 1'b1;
        {10'b0010000000, 1'b1}: next_state[7] = 1'b1;
        {10'b0010000000, *}: out2 = 1'b1;
        
        // S8
        {10'b0100000000, 1'b0}: next_state[0] = 1'b1;
        {10'b0100000000, 1'b1}: next_state[1] = 1'b1;
        {10'b0100000000, *}: out1 = 1'b1;
        
        // S9
        {10'b1000000000, 1'b0}: next_state[0] = 1'b1;
        {10'b1000000000, 1'b1}: next_state[1] = 1'b1;
        {10'b1000000000, *}: begin out1 = 1'b1; out2 = 1'b1; end
        
        // Multiple states
        default: 
            begin
                if (state[0] == 1'b1)
                    begin
                        if (in == 1'b0) next_state[0] = 1'b1;
                        else next_state[1] = 1'b1;
                    end
                if (state[1] == 1'b1)
                    begin
                        if (in == 1'b0) next_state[0] = 1'b1;
                        else next_state[2] = 1'b1;
                    end
                if (state[2] == 1'b1)
                    begin
                        if (in == 1'b0) next_state[0] = 1'b1;
                        else next_state[3] = 1'b1;
                    end
                if (state[3] == 1'b1)
                    begin
                        if (in == 1'b0) next_state[0] = 1'b1;
                        else next_state[4] = 1'b1;
                    end
                if (state[4] == 1'b1)
                    begin
                        if (in == 1'b0) next_state[0] = 1'b1;
                        else next_state[5] = 1'b1;
                    end
                if (state[5] == 1'b1)
                    begin
                        if (in == 1'b0) next_state[8] = 1'b1;
                        else next_state[6] = 1'b1;
                    end
                if (state[6] == 1'b1)
                    begin
                        if (in == 1'b0) next_state[9] = 1'b1;
                        else next_state[7] = 1'b1;
                    end
                if (state[7] == 1'b1)
                    begin
                        if (in == 1'b0) next_state[0] = 1'b1;
                        else next_state[7] = 1'b1;
                        out2 = 1'b1;
                    end
                if (state[8] == 1'b1)
                    begin
                        if (in == 1'b0) next_state[0] = 1'b1;
                        else next_state[1] = 1'b1;
                        out1 = 1'b1;
                    end
                if (state[9] == 1'b1)
                    begin
                        if (in == 1'b0) next_state[0] = 1'b1;
                        else next_state[1] = 1'b1;
                        out1 = 1'b1;
                        out2 = 1'b1;
                    end
            end
    endcase
end

endmodule