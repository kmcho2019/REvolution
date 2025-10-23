module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // Gray code state encoding (only 1 bit changes per transition)
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b011;
    parameter S3 = 3'b010;
    parameter S4 = 3'b110;

    // State register
    reg [2:0] state;

    // Sequential state update with synchronous reset
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

    // Optimized output logic - only check MSB (works with Gray encoding)
    assign z = state[2];

endmodule