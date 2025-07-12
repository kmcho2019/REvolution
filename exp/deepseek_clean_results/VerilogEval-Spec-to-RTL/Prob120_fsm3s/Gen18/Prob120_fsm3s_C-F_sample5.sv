module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding: A=00, B=01, C=10, D=11
    reg [1:0] state;

    // Optimized state transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;  // Reset to state A
        end else begin
            case ({state, in})
                3'b000: state <= 2'b00;  // A,0->A
                3'b001: state <= 2'b01;  // A,1->B
                3'b010: state <= 2'b10;  // B,0->C
                3'b011: state <= 2'b01;  // B,1->B
                3'b100: state <= 2'b00;  // C,0->A
                3'b101: state <= 2'b11;  // C,1->D
                3'b110: state <= 2'b10;  // D,0->C
                3'b111: state <= 2'b01;  // D,1->B
            endcase
        end
    end

    // Most area-efficient output logic
    assign out = &state;  // High only when state=11 (D)

endmodule