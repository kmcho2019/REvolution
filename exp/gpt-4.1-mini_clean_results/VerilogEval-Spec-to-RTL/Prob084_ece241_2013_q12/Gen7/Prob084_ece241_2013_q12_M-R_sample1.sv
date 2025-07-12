module TopModule (
    input        clk,
    input        enable,
    input        S,
    input        A,
    input        B,
    input        C,
    output reg   Z
);

    reg Q [7:0];  // Array of 8 flip-flops Q[0] to Q[7]

    integer i;

    // Shift register: shift right with new bit S entering Q[0]
    always @(posedge clk) begin
        if (enable) begin
            // Shift loop from highest index down to 1
            for (i = 7; i > 0; i = i - 1) begin
                Q[i] <= Q[i-1];
            end
            Q[0] <= S;
        end
    end

    // Multiplexer to select output Z based on {A,B,C} with case statement
    always @(*) begin
        case ({A,B,C})
            3'b000: Z = Q[0];
            3'b001: Z = Q[1];
            3'b010: Z = Q[2];
            3'b011: Z = Q[3];
            3'b100: Z = Q[4];
            3'b101: Z = Q[5];
            3'b110: Z = Q[6];
            3'b111: Z = Q[7];
            default: Z = 1'bx;
        endcase
    end

endmodule