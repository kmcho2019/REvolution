module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Gray-coded state encoding
    parameter [2:0] A = 3'b000,
                    B = 3'b001,
                    C = 3'b011,
                    D = 3'b010,
                    E = 3'b110,
                    F = 3'b111;

    reg [2:0] current_state, next_state;
    reg z_enable;

    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            A: next_state = w ? A : B;
            B: next_state = w ? D : C;
            C: next_state = w ? D : E;
            D: next_state = w ? A : F;
            E: next_state = w ? D : E;
            F: next_state = w ? D : C;
        endcase

        // Output enable logic - only update when state changes to/from E/F
        z_enable = ((current_state == E) | (current_state == F)) ^ 
                  ((next_state == E) | (next_state == F));
    end

    // State register and output register (sequential)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            z <= 1'b0;
        end
        else begin
            current_state <= next_state;
            if (z_enable)
                z <= (next_state == E) | (next_state == F);
        end
    end

endmodule