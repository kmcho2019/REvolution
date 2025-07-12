module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding
    reg [2:0] state;

    // State definitions
    parameter S0 = 3'b000,
              S1 = 3'b001,
              S2 = 3'b010,
              S3 = 3'b011,
              S4 = 3'b100;

    // Next state logic using continuous assignments
    wire [2:0] next_state;
    assign next_state = (state == S0) ? (x ? S1 : S0) :
                       (state == S1) ? (x ? S4 : S1) :
                       (state == S2) ? (x ? S1 : S2) :
                       (state == S3) ? (x ? S2 : S1) :
                       (state == S4) ? (x ? S4 : S3) :
                       S0;  // default case

    // Output logic
    assign z = (state == S3 || state == S4);

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule