module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Binary state encoding
    localparam [2:0] S0 = 3'b000,  // A
                     S1 = 3'b001,  // B
                     S2 = 3'b010,  // C
                     S3 = 3'b011,  // D
                     S4 = 3'b100,  // E
                     S5 = 3'b101;  // F

    reg [2:0] state;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            case (state)
                S0: state <= w ? S1 : S0;
                S1: state <= w ? S2 : S3;
                S2: state <= w ? S4 : S3;
                S3: state <= w ? S5 : S0;
                S4: state <= w ? S4 : S3;
                S5: state <= w ? S2 : S3;
                default: state <= S0;
            endcase
        end
    end

    // Output is high in states E (S4) and F (S5)
    assign z = (state == S4) | (state == S5);

endmodule