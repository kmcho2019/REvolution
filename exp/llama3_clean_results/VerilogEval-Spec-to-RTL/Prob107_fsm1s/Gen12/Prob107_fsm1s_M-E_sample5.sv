module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [0:0] state; // Using a 1-bit register to represent the state

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
    end else begin
        case ({state, in})
            2'b00: state <= 0; // B, in=0 -> B
            2'b01: state <= 0; // B, in=1 -> B
            2'b10: state <= 0; // A, in=0 -> B
            2'b11: state <= 1; // A, in=1 -> A
        endcase
    end
end

always @(*) begin
    case (state)
        1'b0: out = 1'b1; // State B, out=1
        1'b1: out = 1'b0; // State A, out=0
    endcase
end

endmodule