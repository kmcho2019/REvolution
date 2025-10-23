module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Gray-encoded state definitions (only one bit changes per transition)
    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b011;
    localparam S3 = 3'b010;
    localparam S4 = 3'b110;

    // Next state logic
    reg [2:0] next_state;
    always @(*) begin
        case (y)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
        endcase
    end

    // Output logic - optimized combination
    assign Y0 = next_state[0];
    assign z = y[2] | (y[1] & ~y[0]);  // Matches S3 (010) and S4 (110)

endmodule