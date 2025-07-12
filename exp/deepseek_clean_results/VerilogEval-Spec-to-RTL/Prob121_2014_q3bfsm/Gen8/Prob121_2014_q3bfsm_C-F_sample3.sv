module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // State encoding parameters for readability
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    reg [2:0] state;

    // Combined state transition and sequential logic
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else case (state)
            S0: state <= x ? S1 : S0;
            S1: state <= x ? S4 : S1;
            S2: state <= x ? S1 : S2;
            S3: state <= x ? S2 : S1;
            S4: state <= x ? S4 : S3;
            default: state <= S0;  // Robustness for undefined states
        endcase
    end

    // Output logic with blocking assignment
    always @(*) begin
        z = (state == S3) || (state == S4);
    end

endmodule