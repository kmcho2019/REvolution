module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State values carefully chosen for arithmetic transitions
    localparam [2:0] A = 3'd0,
                     B = 3'd1,
                     C = 3'd3,
                     D = 3'd2,
                     E = 3'd6,
                     F = 3'd7;

    reg [2:0] state_counter;

    // State transitions via arithmetic operations
    always @(posedge clk) begin
        if (reset) begin
            state_counter <= A;
        end else begin
            case (state_counter)
                A: state_counter <= w ? (state_counter + 1) : state_counter;  // A→B or stay
                B: state_counter <= w ? (state_counter + 2) : (state_counter + 1);  // B→C or B→D
                C: state_counter <= w ? (state_counter + 3) : (state_counter - 1);  // C→E or C→D
                D: state_counter <= w ? (state_counter + 5) : (state_counter - 2);  // D→F or D→A
                E: state_counter <= w ? state_counter : (state_counter - 2);  // E→E or E→D
                F: state_counter <= w ? (state_counter - 4) : (state_counter - 3);  // F→C or F→D
                default: state_counter <= A;
            endcase
        end
    end

    // Output is MSB of counter (E and F states have MSB set)
    assign z = state_counter[2];

endmodule