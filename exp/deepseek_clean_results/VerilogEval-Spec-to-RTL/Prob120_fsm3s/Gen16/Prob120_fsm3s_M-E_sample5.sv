module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Thermometer-encoded state register (A=1000, B=0100, C=0010, D=0001)
    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 4'b1000;  // Reset to state A
        end
        else begin
            case (state)
                4'b1000: state <= in ? 4'b0100 : 4'b1000;  // A -> B or A
                4'b0100: state <= in ? 4'b0100 : 4'b0010;  // B -> B or C
                4'b0010: state <= in ? 4'b0001 : 4'b1000;  // C -> D or A
                4'b0001: state <= in ? 4'b0100 : 4'b0010;  // D -> B or C
                default: state <= 4'b1000;  // Handle unexpected states
            endcase
        end
    end

    // Output is high only when in state D (0001)
    assign out = state[0];

endmodule