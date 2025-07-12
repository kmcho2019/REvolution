module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state_counter;

    always @(posedge clk) begin
        if (reset) begin
            state_counter <= 2'b00;  // Reset to state A
        end else begin
            case (state_counter)
                2'b00: state_counter <= in ? 2'b01 : 2'b00;  // A: 0->A, 1->B
                2'b01: state_counter <= in ? 2'b01 : 2'b10;  // B: 0->C, 1->B
                2'b10: state_counter <= in ? 2'b11 : 2'b00;  // C: 0->A, 1->D
                2'b11: state_counter <= in ? 2'b01 : 2'b10;  // D: 0->C, 1->B
            endcase
        end
    end

    // Output is high only in state D (11)
    assign out = (state_counter == 2'b11);

endmodule