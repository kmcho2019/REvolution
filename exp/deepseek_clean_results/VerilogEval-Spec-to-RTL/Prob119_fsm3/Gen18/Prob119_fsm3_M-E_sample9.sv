module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding
    parameter [1:0] A = 2'b00,
                   B = 2'b01,
                   C = 2'b10,
                   D = 2'b11;

    reg [1:0] state;
    wire [1:0] next_state_0, next_state_1;
    wire [1:0] next_state;

    // Parallel next state prediction
    assign next_state_0 = (state == A) ? A :
                         (state == B) ? C :
                         (state == C) ? A :
                         /*state == D*/ C;

    assign next_state_1 = (state == A) ? B :
                         (state == B) ? B :
                         (state == C) ? D :
                         /*state == D*/ B;

    // Input-based state selection
    assign next_state = in ? next_state_1 : next_state_0;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign out = (state == D);

endmodule