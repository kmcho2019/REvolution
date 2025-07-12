module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // 4-bit shift register where each bit represents a state
    // A=0001, B=0010, C=0100, D=1000
    reg [3:0] state_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_reg <= 4'b0001;  // Reset to state A
        end else begin
            case (state_reg)
                4'b0001: state_reg <= in ? 4'b0010 : 4'b0001;  // A -> B or A
                4'b0010: state_reg <= in ? 4'b0010 : 4'b0100;  // B -> B or C
                4'b0100: state_reg <= in ? 4'b1000 : 4'b0001;  // C -> D or A
                4'b1000: state_reg <= in ? 4'b0010 : 4'b0100;  // D -> B or C
                default: state_reg <= 4'b0001;
            endcase
        end
    end

    // Output is high only when in state D (1000)
    assign out = state_reg[3];

endmodule