module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding with parameters for clarity
    parameter [2:0] S0 = 3'b000,
                    S1 = 3'b001,
                    S2 = 3'b010,
                    S3 = 3'b011,
                    S4 = 3'b100;

    reg [2:0] state;

    // State transition logic with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else begin
            case (state)
                S0: state <= x ? S1 : S0;
                S1: state <= x ? S4 : S1;
                S2: state <= x ? S1 : S2;
                S3: state <= x ? S2 : S1;
                S4: state <= x ? S4 : S3;
            endcase
        end
    end

    // Output logic - z=1 when in states S3 or S4
    assign z = (state == S3) | (state == S4);

endmodule