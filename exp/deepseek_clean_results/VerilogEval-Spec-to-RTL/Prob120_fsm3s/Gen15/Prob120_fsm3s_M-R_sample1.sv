module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding (A=00, B=01, C=10, D=11)
    reg [1:0] state;

    // Next state logic using continuous assignments
    wire [1:0] next_state;
    assign next_state = (state == 2'b00) ? (in ? 2'b01 : 2'b00) :  // A -> B or A
                       (state == 2'b01) ? (in ? 2'b01 : 2'b10) :  // B -> B or C
                       (state == 2'b10) ? (in ? 2'b11 : 2'b00) :  // C -> D or A
                       (state == 2'b11) ? (in ? 2'b01 : 2'b10) :  // D -> B or C
                       2'b00;                                      // Default to A

    // State and output update
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;  // Reset to state A
            out <= 1'b0;
        end
        else begin
            state <= next_state;
            out <= (next_state == 2'b11);  // Output is 1 only in state D
        end
    end

endmodule