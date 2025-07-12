module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding (6 states)
    localparam [5:0] 
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] current_state;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else begin
            case (1'b1) // synthesis parallel_case
                current_state[A]: current_state <= w ? B : A;
                current_state[B]: current_state <= w ? C : D;
                current_state[C]: current_state <= w ? E : D;
                current_state[D]: current_state <= w ? F : A;
                current_state[E]: current_state <= w ? E : D;
                current_state[F]: current_state <= w ? C : D;
                default: current_state <= A;
            endcase
        end
    end

    // Output z is high for states E and F (bits 4 and 5)
    assign z = current_state[4] | current_state[5];

endmodule