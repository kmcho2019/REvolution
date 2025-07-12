module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // 2-bit state variable (0: A, 1: B, 2: unused)

always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 2'b01; // Reset to state B
        out <= 1'b1;
    end else begin
        case ({state, in})
            2'b00: begin state <= 2'b01; out <= 1'b1; end // A, in=0 -> B
            2'b01: begin state <= 2'b01; out <= 1'b1; end // B, in=0 -> B
            2'b10: begin state <= 2'b00; out <= 1'b0; end // A, in=1 -> A
            2'b11: begin state <= 2'b00; out <= 1'b0; end // B, in=1 -> A
        endcase
    end
end

endmodule