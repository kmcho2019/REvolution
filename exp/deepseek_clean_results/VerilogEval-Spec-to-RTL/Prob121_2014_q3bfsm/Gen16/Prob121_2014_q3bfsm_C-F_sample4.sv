module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // Named state parameters for readability
    parameter [2:0] S0 = 3'b000,
                    S1 = 3'b001,
                    S2 = 3'b010,
                    S3 = 3'b011,
                    S4 = 3'b100;

    reg [2:0] state;

    // Combined state transition and reset logic
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else case (state)
            S0: state <= x ? S1 : S0;
            S1: state <= x ? S4 : S1;
            S2: state <= x ? S1 : S2;
            S3: state <= x ? S2 : S1;
            S4: state <= x ? S4 : S3;
            default: state <= S0;
        endcase
    end

    // Simple combinational output logic
    assign z = (state == S3) || (state == S4);

endmodule