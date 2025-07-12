module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always_comb begin
        // Default assignments
        next_state = 4'b0000;
        
        // State transition logic
        if (state[0]) begin          // State A
            next_state[0] = ~in;
            next_state[1] = in;
        end
        else if (state[1]) begin     // State B
            next_state[1] = in;
            next_state[2] = ~in;
        end
        else if (state[2]) begin     // State C
            next_state[0] = ~in;
            next_state[3] = in;
        end
        else if (state[3]) begin     // State D
            next_state[1] = in;
            next_state[2] = ~in;
        end
    end

    // Output remains the same (just the D state bit)
    assign out = state[3];

endmodule