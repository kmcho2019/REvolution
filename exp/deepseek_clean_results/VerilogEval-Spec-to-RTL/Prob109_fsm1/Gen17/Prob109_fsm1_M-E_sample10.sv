module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Shift register implementation
    reg [1:0] state_shift;

    // State transitions through shifting
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_shift <= 2'b10; // Initialize to B state pattern
        end
        else begin
            case ({state_shift, in})
                3'b000: state_shift <= 2'b01; // A + 0 -> B
                3'b001: state_shift <= 2'b00; // A + 1 -> A
                3'b010: state_shift <= 2'b10; // B + 0 -> A
                3'b011: state_shift <= 2'b11; // B + 1 -> B
                default: state_shift <= 2'b10; // Fallback to B
            endcase
        end
    end

    // Output is MSB of shift register
    assign out = state_shift[1];

endmodule