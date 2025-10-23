module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // Define states
    localparam [1:0] S0 = 2'b00;  // Initial/reset state
    localparam [1:0] S1 = 2'b01;  // Received '1'
    localparam [1:0] S2 = 2'b10;  // Received '10'

    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // State register with async reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Mealy output - depends on state and input
    assign z = (state == S2) && x;

endmodule