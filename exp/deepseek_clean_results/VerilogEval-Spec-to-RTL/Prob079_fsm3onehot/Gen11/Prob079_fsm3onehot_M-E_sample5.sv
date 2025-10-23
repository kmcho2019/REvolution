module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always @(*) begin
        // Initialize next_state to all zeros (safety measure)
        next_state = 4'b0000;
        
        // Priority-based state transitions
        if (state[0]) begin         // State A
            next_state = in ? 4'b0010 : 4'b0001;
        end
        else if (state[1]) begin    // State B
            next_state = in ? 4'b0010 : 4'b0100;
        end
        else if (state[2]) begin    // State C
            next_state = in ? 4'b1000 : 4'b0001;
        end
        else if (state[3]) begin    // State D
            next_state = in ? 4'b0010 : 4'b0100;
        end
    end

    // Output remains simple direct assignment
    assign out = state[3];

endmodule