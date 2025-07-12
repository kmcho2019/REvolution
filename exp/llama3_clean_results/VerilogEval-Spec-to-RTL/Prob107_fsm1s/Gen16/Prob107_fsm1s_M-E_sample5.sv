module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] history; // Shift register to store input history

always @(posedge clk) begin
    if(reset) begin
        history <= 2'b00; // Reset history
    end else begin
        history <= {history[0], in}; // Shift in new input
    end
end

always @(posedge clk) begin
    if(reset) begin
        out <= 1'b1; // Reset output to 1 (state B)
    end else begin
        case(history)
            2'b00, 2'b10: out <= 1'b1; // States corresponding to B
            2'b01, 2'b11: out <= 1'b0; // States corresponding to A
            default: out <= 1'b1; // Default to state B
        endcase
    end
end

endmodule