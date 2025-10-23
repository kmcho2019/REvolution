module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

    reg [2:0] state, next_state;

    // Define states explicitly for readability
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    // Sequential logic: synchronous reset and state register update
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational logic: next state logic separated from output
    always @(*) begin
        // Default next_state assignment for safe synthesis
        next_state = S0; 

        case (state)
            S0: next_state = (x == 1'b0) ? S0 : S1;
            S1: next_state = (x == 1'b0) ? S1 : S4;
            S2: next_state = (x == 1'b0) ? S2 : S1;
            S3: next_state = (x == 1'b0) ? S1 : S2;
            S4: next_state = (x == 1'b0) ? S3 : S4;
            default: next_state = S0;
        endcase
    end

    // Combinational output logic separate from next_state
    always @(*) begin
        if (state == S3 || state == S4)
            z = 1'b1;
        else
            z = 1'b0;
    end

endmodule