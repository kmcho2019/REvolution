module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    always @(*) begin
        // Default assignment
        next_state = 4'b0000;
        
        // State transition logic
        if (state == A) begin
            next_state = in ? B : A;
        end
        else if (state == B) begin
            next_state = in ? B : C;
        end
        else if (state == C) begin
            next_state = in ? D : A;
        end
        else if (state == D) begin
            next_state = in ? B : C;
        end
    end

    // Output logic remains the same
    assign out = state[3];

endmodule