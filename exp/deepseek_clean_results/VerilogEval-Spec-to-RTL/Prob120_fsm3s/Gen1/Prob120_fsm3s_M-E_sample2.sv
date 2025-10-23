module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State counter (A=0, B=1, C=2, D=3)
    reg [1:0] state_counter;

    // State transition logic using arithmetic operations
    always @(posedge clk) begin
        if (reset) begin
            state_counter <= 2'b00;  // Reset to state A
        end else begin
            case (state_counter)
                2'b00: state_counter <= in ? 2'b01 : 2'b00;  // A -> B if in=1, else stay
                2'b01: state_counter <= in ? 2'b01 : 2'b10;  // B -> C if in=0, else stay
                2'b10: state_counter <= in ? 2'b11 : 2'b00;  // C -> D if in=1, else A
                2'b11: state_counter <= in ? 2'b01 : 2'b10;  // D -> B if in=1, else C
            endcase
        end
    end

    // Output is high only when in state D (counter=3)
    assign out = (state_counter == 2'b11);

endmodule