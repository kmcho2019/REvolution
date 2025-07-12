module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // Gray-like state encoding to minimize bit transitions
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b011;  // Changed from 010 to minimize transitions
    parameter S3 = 3'b010;  // Changed from 011
    parameter S4 = 3'b110;  // Changed from 100

    reg [2:0] state;

    // Output logic using parameter references for clarity
    assign z = (state == S3) || (state == S4);

    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else case (state)
            S0: state <= x ? S1 : S0;
            S1: state <= x ? S4 : S1;
            S2: state <= x ? S1 : S2;
            S3: state <= x ? S2 : S1;
            S4: state <= x ? S4 : S3;
            default: state <= S0;  // Safe default
        endcase
    end

endmodule