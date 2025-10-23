module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    reg [2:0] state_counter;

    // State transitions using arithmetic
    always @(posedge clk) begin
        if (reset) begin
            state_counter <= 3'b000;  // State A
        end
        else begin
            case (state_counter)
                3'b000: state_counter <= w ? 3'b000 : 3'b001;  // A -> A or B
                3'b001: state_counter <= w ? 3'b011 : 3'b010;  // B -> D or C
                3'b010: state_counter <= w ? 3'b011 : 3'b100;  // C -> D or E
                3'b011: state_counter <= w ? 3'b000 : 3'b101;  // D -> A or F
                3'b100: state_counter <= w ? 3'b011 : 3'b100;  // E -> D or E
                3'b101: state_counter <= w ? 3'b011 : 3'b010;  // F -> D or C
                default: state_counter <= 3'b000;
            endcase
        end
    end

    // Output is MSB (states E and F have MSB set)
    assign z = state_counter[2];

endmodule