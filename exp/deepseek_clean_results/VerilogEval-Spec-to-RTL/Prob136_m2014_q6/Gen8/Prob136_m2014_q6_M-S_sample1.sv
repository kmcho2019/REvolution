module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;  // State A
        end else begin
            case (state)
                3'b000: state <= w ? 3'b000 : 3'b001;  // A -> A or B
                3'b001: state <= w ? 3'b010 : 3'b011;  // B -> D or C
                3'b011: state <= w ? 3'b010 : 3'b110;  // C -> D or E
                3'b010: state <= w ? 3'b000 : 3'b100;  // D -> A or F
                3'b110: state <= w ? 3'b010 : 3'b110;  // E -> D or E
                3'b100: state <= w ? 3'b010 : 3'b011;  // F -> D or C
            endcase
        end
    end

    assign z = state[2];  // Output is MSB of state

endmodule