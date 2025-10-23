module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding parameters
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    // State register and next state
    reg [2:0] state;
    wire [2:0] next_state;

    // Combinational next state logic
    assign next_state = 
        (state == S0) ? (x ? S1 : S0) :
        (state == S1) ? (x ? S4 : S1) :
        (state == S2) ? (x ? S1 : S2) :
        (state == S3) ? (x ? S2 : S1) :
        (state == S4) ? (x ? S4 : S3) :
        S0;  // Default case (should never occur)

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic remains the same
    assign z = (state == S3) || (state == S4);

endmodule