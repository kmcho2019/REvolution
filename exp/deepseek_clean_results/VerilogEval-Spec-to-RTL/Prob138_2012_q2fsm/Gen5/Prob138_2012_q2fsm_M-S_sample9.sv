module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] current_state;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else begin
            case (1'b1)  // synthesis parallel_case
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

    // Output is directly bits 4 or 5 (E or F)
    assign z = current_state[4] | current_state[5];

endmodule