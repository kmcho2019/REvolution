module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // State encoding parameters (clear naming from Example 2)
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    // State register
    reg [2:0] state;

    // Output logic (most efficient implementation from Example 2)
    assign z = (state == S3) || (state == S4);

    // State transition logic (compact single always block from Example 1)
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

endmodule