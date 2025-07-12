module TopModule (
    input  clk,
    input  reset,
    input  x,
    output z
);

    // State encoding using localparam for clarity and maintainability
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    reg [2:0] state;

    wire [2:0] next_state;

    // Next state logic as combinational assigns based on current state and input x
    assign next_state = (state == S0) ? (x ? S1 : S0) :
                        (state == S1) ? (x ? S4 : S1) :
                        (state == S2) ? (x ? S1 : S2) :
                        (state == S3) ? (x ? S2 : S1) :
                        (state == S4) ? (x ? S4 : S3) :
                        S0; // default fallback

    // Sequential logic: synchronous active-high reset and state update
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic derived directly from state (z=1 for S3 and S4, else 0)
    assign z = (state == S3) || (state == S4);

endmodule