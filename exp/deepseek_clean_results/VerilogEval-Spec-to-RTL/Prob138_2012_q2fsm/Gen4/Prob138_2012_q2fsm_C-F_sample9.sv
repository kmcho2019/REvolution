module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray code state encoding for minimal transitions
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,
                     F = 3'b111;

    reg [2:0] state;

    // Combined state transition and storage (single always block)
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else begin
            case (state)
                A: state <= w ? B : A;
                B: state <= w ? C : D;
                C: state <= w ? E : D;
                D: state <= w ? F : A;
                E: state <= w ? E : D;
                F: state <= w ? C : D;
            endcase
        end
    end

    // Output logic - z is 1 in states E and F
    assign z = (state == E) | (state == F);

endmodule