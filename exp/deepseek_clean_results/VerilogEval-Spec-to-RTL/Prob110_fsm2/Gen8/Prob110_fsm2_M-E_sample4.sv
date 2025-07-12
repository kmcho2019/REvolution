module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    reg [1:0] state_shift;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_shift <= 2'b01;  // Initialize to OFF state
        end else begin
            case (state_shift)
                2'b01: state_shift <= j ? 2'b10 : 2'b01;  // OFF state transitions
                2'b10: state_shift <= k ? 2'b01 : 2'b10;  // ON state transitions
                default: state_shift <= 2'b01;             // Auto-correct invalid states
            endcase
        end
    end

    // Output is MSB of shift register (0 for OFF, 1 for ON)
    assign out = state_shift[1];

endmodule