module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Binary state encoding (3 bits for 6 states)
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b010,
                     D = 3'b011,
                     E = 3'b100,
                     F = 3'b101;

    reg [2:0] state;

    // State transition and storage
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