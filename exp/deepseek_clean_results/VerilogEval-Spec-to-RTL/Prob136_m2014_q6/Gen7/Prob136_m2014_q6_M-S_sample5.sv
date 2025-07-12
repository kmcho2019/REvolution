module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Binary state encoding
    reg [2:0] state;

    // State transition logic
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;  // State A
        else begin
            case (state)
                3'b000: state <= w ? 3'b000 : 3'b001;  // A -> A or B
                3'b001: state <= w ? 3'b011 : 3'b010;  // B -> D or C
                3'b010: state <= w ? 3'b011 : 3'b100;  // C -> D or E
                3'b011: state <= w ? 3'b000 : 3'b101;  // D -> A or F
                3'b100: state <= w ? 3'b011 : 3'b100;  // E -> D or E
                3'b101: state <= w ? 3'b011 : 3'b010;  // F -> D or C
                default: state <= 3'b000;
            endcase
        end
    end

    // Output is 1 for states E (100) and F (101)
    assign z = (state == 3'b100) | (state == 3'b101);

endmodule