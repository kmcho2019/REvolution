module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Binary state encoding
    localparam [2:0] 
        S0 = 3'b000,  // A
        S1 = 3'b001,  // B
        S2 = 3'b010,  // C
        S3 = 3'b011,  // D
        S4 = 3'b100,  // E
        S5 = 3'b101;  // F

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else case (state)
            S0: state <= w ? S0 : S1;
            S1: state <= w ? S3 : S2;
            S2: state <= w ? S3 : S4;
            S3: state <= w ? S0 : S5;
            S4: state <= w ? S3 : S4;
            S5: state <= w ? S3 : S2;
            default: state <= S0;
        endcase
    end

    // Output is high in states E (S4) or F (S5)
    assign z = (state == S4) | (state == S5);

endmodule