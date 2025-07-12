module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State definitions via counter values
    parameter [2:0] A_val = 3'b000,
                    B_val = 3'b001,
                    C_val = 3'b010,
                    D_val = 3'b011,
                    E_val = 3'b100,
                    F_val = 3'b101;

    reg [2:0] state_counter;

    // Counter-based state transitions
    always @(posedge clk) begin
        if (reset) begin
            state_counter <= A_val;
        end else begin
            case (state_counter)
                A_val: state_counter <= w ? A_val : B_val;
                B_val: state_counter <= w ? D_val : C_val;
                C_val: state_counter <= w ? D_val : E_val;
                D_val: state_counter <= w ? A_val : F_val;
                E_val: state_counter <= w ? D_val : E_val;
                F_val: state_counter <= w ? D_val : C_val;
                default: state_counter <= A_val;
            endcase
        end
    end

    // Output logic - z=1 when counter is E_val or F_val
    assign z = (state_counter == E_val) | (state_counter == F_val);

endmodule