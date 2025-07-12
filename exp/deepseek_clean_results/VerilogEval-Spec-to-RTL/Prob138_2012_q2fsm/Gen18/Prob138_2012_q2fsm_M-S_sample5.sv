module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    reg [2:0] state;

    // Combined state transition and storage
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000; // A
        end else begin
            case (state)
                3'b000: state <= w ? 3'b001 : 3'b000; // A -> B or A
                3'b001: state <= w ? 3'b010 : 3'b011; // B -> C or D
                3'b010: state <= w ? 3'b100 : 3'b011; // C -> E or D
                3'b011: state <= w ? 3'b101 : 3'b000; // D -> F or A
                3'b100: state <= w ? 3'b100 : 3'b011; // E -> E or D
                3'b101: state <= w ? 3'b010 : 3'b011; // F -> C or D
                default: state <= 3'b000; // A
            endcase
        end
    end

    // Output is 1 for states E (100) and F (101)
    assign z = state[2];

endmodule