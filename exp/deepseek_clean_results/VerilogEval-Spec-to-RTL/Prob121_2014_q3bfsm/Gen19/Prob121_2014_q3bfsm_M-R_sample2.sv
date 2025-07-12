module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding
    parameter [2:0] S0 = 3'b000,
                    S1 = 3'b001,
                    S2 = 3'b010,
                    S3 = 3'b011,
                    S4 = 3'b100;

    reg [2:0] state;
    wire [2:0] next_state;

    // Combinational next state logic
    assign next_state = 
        (reset) ? S0 :  // Reset has highest priority
        (state == S0) ? (x ? S1 : S0) :
        (state == S1) ? (x ? S4 : S1) :
        (state == S2) ? (x ? S1 : S2) :
        (state == S3) ? (x ? S2 : S1) :
        (state == S4) ? (x ? S4 : S3) :
        S0;  // Default case (should never be used)

    // State register
    always @(posedge clk) begin
        state <= next_state;
    end

    // Combinational output logic
    assign z = (state == S3) || (state == S4);

endmodule