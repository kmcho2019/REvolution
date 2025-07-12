module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // 2-bit shift register for state representation
    // [1] = A state (10), [0] = B state (01)
    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b01;  // Reset to state B
        end else begin
            case (state)
                2'b01: state <= in ? 2'b01 : 2'b10;  // B state transitions
                2'b10: state <= in ? 2'b10 : 2'b01;  // A state transitions
                default: state <= 2'b01;             // Safety catch
            endcase
        end
    end

    // Output is high when in state B (01)
    assign out = ~state[1];

endmodule