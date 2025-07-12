module TopModule(
    input clk,
    input reset,
    input x,
    output z
);
    // Gray-coded state encoding for reduced switching activity
    localparam S0 = 3'b000; // 000
    localparam S1 = 3'b001; // 001
    localparam S2 = 3'b011; // 010 -> 011 Gray code
    localparam S3 = 3'b010; // 011 -> 010 Gray code
    localparam S4 = 3'b110; // 100 -> 110 Gray code

    reg [2:0] y, y_next;

    // Next state logic (combinational) based on Gray-coded states
    always @(*) begin
        case (y)
            S0: y_next = x ? S1 : S0;
            S1: y_next = x ? S4 : S1;
            S2: y_next = x ? S1 : S2;
            S3: y_next = x ? S2 : S1;
            S4: y_next = x ? S4 : S3;
            default: y_next = S0;
        endcase
    end

    // State register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            y <= S0;
        else
            y <= y_next;
    end

    // Output logic as a combinational function matching Gray-coded states with output=1 only in S3 and S4
    // S3 = 3'b010, S4 = 3'b110
    assign z = (y == S3) || (y == S4);

endmodule