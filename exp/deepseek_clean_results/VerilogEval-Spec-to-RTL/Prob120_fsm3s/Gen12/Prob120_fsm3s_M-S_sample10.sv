module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding (A=00, B=01, C=10, D=11)
    reg [1:0] state;

    // Combined state transition and register update
    always @(posedge clk) begin
        if (reset)
            state <= 2'b00;  // Reset to state A
        else begin
            case (state)
                2'b00: state <= in ? 2'b01 : 2'b00;  // A -> B or A
                2'b01: state <= in ? 2'b01 : 2'b10;  // B -> B or C
                2'b10: state <= in ? 2'b11 : 2'b00;  // C -> D or A
                2'b11: state <= in ? 2'b01 : 2'b10;  // D -> B or C
            endcase
        end
    end

    // Output logic - only high when state is D (11)
    assign out = (state == 2'b11);

endmodule