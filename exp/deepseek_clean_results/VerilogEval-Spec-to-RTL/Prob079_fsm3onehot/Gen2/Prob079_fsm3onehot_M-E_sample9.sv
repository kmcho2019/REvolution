module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // Priority-based state transition logic (D has highest priority)
    always @(*) begin
        // Default to state A (lowest priority)
        next_state = 4'b0001;
        
        // State D transitions (highest priority)
        if (state[3]) begin
            next_state = in ? 4'b0010 : 4'b0100;  // D -> B(in=1) or C(in=0)
        end
        // State C transitions
        else if (state[2]) begin
            next_state = in ? 4'b1000 : 4'b0001;  // C -> D(in=1) or A(in=0)
        end
        // State B transitions
        else if (state[1]) begin
            next_state = in ? 4'b0010 : 4'b0100;  // B -> B(in=1) or C(in=0)
        end
        // State A transitions (lowest priority)
        else if (state[0]) begin
            next_state = in ? 4'b0010 : 4'b0001;  // A -> B(in=1) or A(in=0)
        end
    end

    // Output remains direct from state bit
    assign out = state[3];

endmodule