module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding optimized for output logic and transitions
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    // State register
    reg [2:0] state;

    // Optimized state transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            case (state)
                S0: state <= {2'b0, x};          // S0 -> S0 or S1
                S1: state <= x ? S4 : S1;        // S1 -> S1 or S4
                S2: state <= {1'b0, ~x, x};      // S2 -> S2 or S1
                S3: state <= {1'b0, x, ~x};      // S3 -> S1 or S2
                S4: state <= {1'b0, ~x, x|~x};    // S4 -> S3 or S4
            endcase
        end
    end

    // Optimized output logic - uses direct state bit checks
    assign z = state[2] | (state == S3);

endmodule