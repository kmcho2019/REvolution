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

    // Output is MSB of state (1 for E/F)
    assign z = state[2];

    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            case (state)
                S0: state <= w ? S0 : S1;
                S1: state <= w ? S3 : S2;
                S2: state <= w ? S3 : S4;
                S3: state <= w ? S0 : S5;
                S4: state <= w ? S3 : S4;
                S5: state <= w ? S3 : S2;
                default: state <= S0;
            endcase
        end
    end

endmodule