module TopModule (
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);

    always @(*) begin
        // Default outputs
        Y1 = 1'b0;
        Y3 = 1'b0;

        casez (y)
            6'b000001: begin // State A (y[0])
                if (w) Y1 = 1'b1;     // A->B on w=1 sets Y1 (input to y[1])
                // no transition to D here, so Y3=0
            end
            6'b000010: begin // State B (y[1])
                if (~w) Y3 = 1'b1;    // B->D on w=0 sets Y3 (input to y[3])
            end
            6'b000100: begin // State C (y[2])
                if (~w) Y3 = 1'b1;    // C->D on w=0 sets Y3
            end
            6'b001000: begin // State D (y[3])
                if (w) Y3 = 1'b1;     // D->F or D->D? FSM shows D->F on w=1, but F is y[5], so no Y1 or Y3 here
                // D->A on w=0, no Y1 or Y3
                // According to the FSM, no transition to B or D from D on w=1 or w=0 except itself or others, so no output
                // So nothing to assign for Y1 or Y3 here
            end
            6'b010000: begin // State E (y[4])
                if (~w) Y3 = 1'b1;    // E->D on w=0 sets Y3
            end
            6'b100000: begin // State F (y[5])
                if (~w) Y3 = 1'b1;    // F->D on w=0 sets Y3
            end
            default: begin
                // No valid state: outputs remain 0
            end
        endcase
    end

endmodule