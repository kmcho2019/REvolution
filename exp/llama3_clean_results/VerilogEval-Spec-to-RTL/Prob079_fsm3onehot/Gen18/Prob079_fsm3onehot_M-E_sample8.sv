module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    reg [3:0] next_state_reg;
    reg out_reg;

    always @(*) begin
        case (state)
            4'b0001: begin // State A
                if (in) begin
                    next_state_reg = 4'b0010; // Next state B
                    out_reg = 1'b0; // Output 0
                end else begin
                    next_state_reg = 4'b0001; // Next state A
                    out_reg = 1'b0; // Output 0
                end
            end
            4'b0010: begin // State B
                if (in) begin
                    next_state_reg = 4'b0010; // Next state B
                    out_reg = 1'b0; // Output 0
                end else begin
                    next_state_reg = 4'b0100; // Next state C
                    out_reg = 1'b0; // Output 0
                end
            end
            4'b0100: begin // State C
                if (in) begin
                    next_state_reg = 4'b1000; // Next state D
                    out_reg = 1'b0; // Output 0
                end else begin
                    next_state_reg = 4'b0001; // Next state A
                    out_reg = 1'b0; // Output 0
                end
            end
            4'b1000: begin // State D
                if (in) begin
                    next_state_reg = 4'b0010; // Next state B
                    out_reg = 1'b1; // Output 1
                end else begin
                    next_state_reg = 4'b0100; // Next state C
                    out_reg = 1'b1; // Output 1
                end
            end
            default: begin
                next_state_reg = 4'bxxxx; // Invalid state
                out_reg = 1'b0; // Output 0
            end
        endcase
    end

    assign next_state = next_state_reg;
    assign out = out_reg;

endmodule