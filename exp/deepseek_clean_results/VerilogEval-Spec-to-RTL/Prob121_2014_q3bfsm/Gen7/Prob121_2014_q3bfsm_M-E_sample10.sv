module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding
    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b010;
    localparam S3 = 3'b011;
    localparam S4 = 3'b100;

    // State registers
    reg [2:0] current_state, next_state;
    reg [2:0] next_state_x0, next_state_x1;

    // Parallel next state computation
    always @(*) begin
        case (current_state)
            S0: begin next_state_x0 = S0; next_state_x1 = S1; end
            S1: begin next_state_x0 = S1; next_state_x1 = S4; end
            S2: begin next_state_x0 = S2; next_state_x1 = S1; end
            S3: begin next_state_x0 = S1; next_state_x1 = S2; end
            S4: begin next_state_x0 = S3; next_state_x1 = S4; end
            default: begin next_state_x0 = S0; next_state_x1 = S0; end
        endcase
    end

    // Next state selection
    assign next_state = x ? next_state_x1 : next_state_x0;

    // State update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Output logic
    assign z = (current_state == S3) || (current_state == S4);

endmodule