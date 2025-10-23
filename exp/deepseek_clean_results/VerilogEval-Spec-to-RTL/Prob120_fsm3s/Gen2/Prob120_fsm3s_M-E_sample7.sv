module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // 2-bit saturating counter representing state
    reg [1:0] state_counter;

    // Counter update logic
    always @(posedge clk) begin
        if (reset) begin
            state_counter <= 2'b00;  // State A
        end else begin
            case (state_counter)
                2'b00: state_counter <= in ? 2'b01 : 2'b00;  // A → B if in=1, else stay A
                2'b01: state_counter <= in ? 2'b01 : 2'b10;  // B → B if in=1, else C
                2'b10: state_counter <= in ? 2'b11 : 2'b00;  // C → D if in=1, else A
                2'b11: state_counter <= in ? 2'b01 : 2'b10;  // D → B if in=1, else C
            endcase
        end
    end

    // Output is high only when in state D (counter = 3)
    assign out = (state_counter == 2'b11);

endmodule