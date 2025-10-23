module TopModule (
    input        clk,
    input        reset,
    input        x,
    output reg   z
);

    // State encoding
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    reg [2:0] state, next_state;

    // Next state logic as combinational functions (using assign)
    wire [2:0] next_state_x0, next_state_x1;

    // Define next state for x=0
    assign next_state_x0 =
        (state == S0) ? S0 :
        (state == S1) ? S1 :
        (state == S2) ? S2 :
        (state == S3) ? S1 :
        (state == S4) ? S3 :
        S0; // default safe state

    // Define next state for x=1
    assign next_state_x1 =
        (state == S0) ? S1 :
        (state == S1) ? S4 :
        (state == S2) ? S1 :
        (state == S3) ? S2 :
        (state == S4) ? S4 :
        S0; // default safe state

    // Combine next state according to input x
    always @(*) begin
        next_state = (x) ? next_state_x1 : next_state_x0;
    end

    // Synchronous process for state and output update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // Output z registered: 1 only in states S3 or S4
            z <= (next_state == S3) || (next_state == S4);
        end
    end

endmodule