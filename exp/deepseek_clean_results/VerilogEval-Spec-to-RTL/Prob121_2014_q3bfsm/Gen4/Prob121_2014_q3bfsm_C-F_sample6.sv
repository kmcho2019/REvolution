module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // Gray-coded state encoding for minimal bit transitions
    parameter S0 = 3'b000,  // 000
              S1 = 3'b001,  // 001
              S2 = 3'b011,  // 010 -> 011 (Gray code)
              S3 = 3'b010,  // 011 -> 010 (Gray code)
              S4 = 3'b110;  // 100 -> 110 (Gray code)

    reg [2:0] y;  // Current state

    // State transitions with Gray coding
    always @(posedge clk) begin
        if (reset) begin
            y <= S0;  // Synchronous reset to state 000
        end else begin
            case (y)
                S0: y <= x ? S1 : S0;
                S1: y <= x ? S4 : S1;
                S2: y <= x ? S1 : S2;
                S3: y <= x ? S2 : S1;
                S4: y <= x ? S4 : S3;
            endcase
        end
    end

    // Output is combinational function of current state
    assign z = (y == S3) || (y == S4);  // States where z=1

endmodule