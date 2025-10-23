module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    always @(*) begin
        // Priority-based state transitions
        if (state[0]) begin            // State A
            next_state = in ? 4'b0010 : 4'b0001;  // A->B if in=1, else stay A
        end
        else if (state[1]) begin       // State B
            next_state = in ? 4'b0010 : 4'b0100;  // B->B if in=1, else B->C
        end
        else if (state[2]) begin       // State C
            next_state = in ? 4'b1000 : 4'b0001;  // C->D if in=1, else C->A
        end
        else begin                     // State D
            next_state = in ? 4'b0010 : 4'b0100;  // D->B if in=1, else D->C
        end
    end

    // Output is simply the D state bit
    assign out = state[3];

endmodule