module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg out
);

reg [1:0] state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // State A
    end else begin
        case (state)
            2'b00: state <= (in)? 2'b01 : 2'b00; // A
            2'b01: state <= (in)? 2'b01 : 2'b10; // B
            2'b10: state <= (in)? 2'b11 : 2'b00; // C
            2'b11: state <= (in)? 2'b01 : 2'b10; // D
            default: state <= 2'b00; // Default to A
        endcase
    end
end

always_comb begin
    case (state)
        2'b00, 2'b01, 2'b10: out = 1'b0; // A, B, C
        2'b11: out = 1'b1; // D
        default: out = 1'b0; // Default output
    endcase
end

endmodule