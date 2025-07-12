module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

// State counter implementation
reg [2:0] state_counter;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        state_counter <= 0;  // State A
        z <= 0;
    end
    else begin
        case (state_counter)
            0: begin  // State A
                z <= 0;
                state_counter <= w ? 0 : 1;  // A->A or A->B
            end
            1: begin  // State B
                z <= 0;
                state_counter <= w ? 3 : 2;  // B->D or B->C
            end
            2: begin  // State C
                z <= 0;
                state_counter <= w ? 3 : 4;  // C->D or C->E
            end
            3: begin  // State D
                z <= 0;
                state_counter <= w ? 0 : 5;  // D->A or D->F
            end
            4: begin  // State E
                z <= 1;
                state_counter <= w ? 3 : 4;  // E->D or E->E
            end
            5: begin  // State F
                z <= 1;
                state_counter <= w ? 3 : 2;  // F->D or F->C
            end
            default: begin
                z <= 0;
                state_counter <= 0;
            end
        endcase
    end
end

endmodule