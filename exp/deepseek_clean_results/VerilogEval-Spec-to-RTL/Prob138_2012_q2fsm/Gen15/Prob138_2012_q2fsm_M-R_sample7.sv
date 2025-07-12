module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam [5:0] A = 6'b000001,
                     B = 6'b000010,
                     C = 6'b000100,
                     D = 6'b001000,
                     E = 6'b010000,
                     F = 6'b100000;

    reg [5:0] current_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else begin
            case (current_state)
                A: current_state <= w ? B : A;
                B: current_state <= w ? C : D;
                C: current_state <= w ? E : D;
                D: current_state <= w ? F : A;
                E: current_state <= w ? E : D;
                F: current_state <= w ? C : D;
                default: current_state <= A;
            endcase
        end
    end

    // Output is high when in E or F states
    assign z = current_state[4] | current_state[5];

endmodule