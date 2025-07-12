module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    reg [2:0] state_counter;

    // State transitions using counter arithmetic
    always @(posedge clk) begin
        if (reset) begin
            state_counter <= 3'b000;  // State A
        end else begin
            case (state_counter)
                3'b000: state_counter <= w ? 3'b000 : 3'b001;  // A -> A or B
                3'b001: state_counter <= w ? 3'b010 : 3'b011;  // B -> D or C
                3'b011: state_counter <= w ? 3'b010 : 3'b110;  // C -> D or E
                3'b010: state_counter <= w ? 3'b000 : 3'b100;  // D -> A or F
                3'b110: state_counter <= w ? 3'b010 : 3'b110;  // E -> D or E
                3'b100: state_counter <= w ? 3'b010 : 3'b011;  // F -> D or C
                default: state_counter <= 3'b000;  // Fallback to A
            endcase
        end
    end

    // Output is 1 for states E (110) and F (100)
    assign z = (state_counter == 3'b110) | (state_counter == 3'b100);

endmodule