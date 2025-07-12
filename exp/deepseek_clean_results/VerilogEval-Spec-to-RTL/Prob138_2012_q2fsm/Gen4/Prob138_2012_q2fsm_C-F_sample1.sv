module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Binary state encoding with explicit names
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b010,
                     D = 3'b011,
                     E = 3'b100,
                     F = 3'b101;

    reg [2:0] state;

    // Combined state transition and storage
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

    // Optimized output logic - E and F share MSB=1
    assign z = state[2];  // E=100, F=101 -> both have bit 2 set

endmodule