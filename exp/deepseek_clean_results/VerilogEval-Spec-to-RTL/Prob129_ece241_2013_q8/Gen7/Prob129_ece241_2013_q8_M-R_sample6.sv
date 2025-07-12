module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // Define state encoding
    localparam [1:0] S0 = 2'b00,  // Initial state
                     S1 = 2'b01,  // Received '1'
                     S2 = 2'b10;  // Received '10'

    reg [1:0] current_state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // State register (sequential)
    always @(posedge clk or negedge aresetn)
        if (!aresetn) current_state <= S0;
        else current_state <= next_state;

    // Mealy output (combinational)
    assign z = (current_state == S2) & x;

endmodule