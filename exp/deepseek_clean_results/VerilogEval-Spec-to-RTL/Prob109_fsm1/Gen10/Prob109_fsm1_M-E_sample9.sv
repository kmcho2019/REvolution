module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg [1:0] state_shift;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_shift <= 2'b11;  // Initialize to state B
        end else begin
            case ({state_shift, in})
                3'b000: state_shift <= 2'b10;  // A(00) + 0 -> B(10)
                3'b001: state_shift <= 2'b00;  // A(00) + 1 -> A(00)
                3'b100: state_shift <= 2'b00;  // B(10) + 0 -> A(00)
                3'b101: state_shift <= 2'b10;  // B(10) + 1 -> B(10)
                default: state_shift <= 2'b11; // Fallback to B
            endcase
        end
    end

    // Output is MSB of shift register
    assign out = state_shift[1];

endmodule