module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding with parameters
    parameter [2:0] S0 = 3'b000,
                    S1 = 3'b001,
                    S2 = 3'b010,
                    S3 = 3'b011,
                    S4 = 3'b100;

    reg [2:0] state;

    // Next state logic using continuous assignments
    wire [2:0] next_state = 
        (state == S0) ? (x ? S1 : S0) :
        (state == S1) ? (x ? S4 : S1) :
        (state == S2) ? (x ? S1 : S2) :
        (state == S3) ? (x ? S2 : S1) :
        (state == S4) ? (x ? S4 : S3) :
        S0;  // default case

    // Output logic - z=1 when state is S3 or S4
    assign z = (state == S3) | (state == S4);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule