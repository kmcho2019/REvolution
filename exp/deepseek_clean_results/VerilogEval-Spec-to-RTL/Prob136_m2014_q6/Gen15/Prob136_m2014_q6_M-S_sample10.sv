module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    reg [2:0] state; // States: A=000, B=001, C=010, D=011, E=100, F=101

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000; // Reset to state A
        end else begin
            case (state)
                3'b000: state <= w ? 3'b000 : 3'b001; // A
                3'b001: state <= w ? 3'b011 : 3'b010; // B
                3'b010: state <= w ? 3'b011 : 3'b100; // C
                3'b011: state <= w ? 3'b000 : 3'b101; // D
                3'b100: state <= w ? 3'b011 : 3'b100; // E
                3'b101: state <= w ? 3'b011 : 3'b010; // F
            endcase
        end
    end

    assign z = state[2]; // Output is MSB (1 for E and F)

endmodule