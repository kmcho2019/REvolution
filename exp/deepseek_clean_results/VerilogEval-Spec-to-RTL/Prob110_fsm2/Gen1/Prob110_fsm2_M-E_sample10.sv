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
            state_shift <= 2'b01;  // Reset to OFF state (01)
        end else begin
            case (state_shift)
                2'b01: state_shift <= j ? 2'b10 : 2'b01;  // OFF to ON if j=1
                2'b10: state_shift <= k ? 2'b01 : 2'b10;  // ON to OFF if k=1
                default: state_shift <= 2'b01;             // Handle invalid states
            endcase
        end
    end

    // Output is MSB of shift register (1 for ON, 0 for OFF)
    assign out = state_shift[1];

endmodule