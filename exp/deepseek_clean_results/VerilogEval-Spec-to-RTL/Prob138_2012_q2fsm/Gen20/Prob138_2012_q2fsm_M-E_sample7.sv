module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State values (counter-based)
    reg [2:0] state_counter;

    // Output prediction
    assign z = (state_counter >= 3'd4);  // E=4, F=5

    // Arithmetic-based state transitions
    always @(posedge clk) begin
        if (reset) begin
            state_counter <= 3'd0;  // Reset to A
        end else begin
            case (state_counter)
                3'd0: state_counter <= w ? 3'd1 : 3'd0;  // A->B or A->A
                3'd1: state_counter <= w ? 3'd2 : 3'd3;  // B->C or B->D
                3'd2: state_counter <= w ? 3'd4 : 3'd3;  // C->E or C->D
                3'd3: state_counter <= w ? 3'd5 : 3'd0;  // D->F or D->A
                3'd4: state_counter <= w ? 3'd4 : 3'd3;  // E->E or E->D
                3'd5: state_counter <= w ? 3'd2 : 3'd3;  // F->C or F->D
                default: state_counter <= 3'd0;           // Safety net
            endcase
        end
    end

endmodule