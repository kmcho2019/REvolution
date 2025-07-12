module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding with output prediction in LSB
    // Format: {state_bits, predicted_z}
    localparam [2:0] 
        A = 3'b00_0,  // z=0
        B = 3'b01_0,  // z=0
        C = 3'b10_0,  // z=0
        D = 3'b11_0,  // z=0
        E = 3'b00_1,  // z=1
        F = 3'b01_1;  // z=1

    reg [2:0] state;

    // Next state logic with embedded output prediction
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
        end else begin
            case (state[2:1])  // Ignore LSB (output) for state transitions
                2'b00: state <= w ? A : B;      // A
                2'b01: state <= w ? D : C;      // B
                2'b10: state <= w ? D : E;      // C
                2'b11: state <= w ? A : F;      // D
                default: state <= state;         // E/F handled by LSB
            endcase
        end
    end

    // Output is simply the predicted bit from state encoding
    assign z = state[0];

endmodule