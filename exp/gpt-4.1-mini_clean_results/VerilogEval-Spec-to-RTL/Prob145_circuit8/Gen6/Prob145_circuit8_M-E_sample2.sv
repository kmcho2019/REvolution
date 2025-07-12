module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

    // 2-bit state register: state[1]=q, state[0]=p
    reg [1:0] state;

    // State encoding (for clarity):
    // 00, 01, 11, 10 - to be determined by input 'a' and current state to match waveform.

    always @(posedge clock) begin
        case (state)
            2'b00: begin
                // When in 00, if a=1 move to 01 else remain 00
                if (a)
                    state <= 2'b01;
                else
                    state <= 2'b00;
            end
            2'b01: begin
                // When in 01, if a=1 move to 11 else go back to 00
                if (a)
                    state <= 2'b11;
                else
                    state <= 2'b00;
            end
            2'b11: begin
                // When in 11, if a=1 remain 11 else go to 10
                if (a)
                    state <= 2'b11;
                else
                    state <= 2'b10;
            end
            2'b10: begin
                // When in 10, if a=1 move to 11 else go to 00
                if (a)
                    state <= 2'b11;
                else
                    state <= 2'b00;
            end
            default: state <= 2'b00;
        endcase
    end

    // Outputs reflect the state bits
    always @(*) begin
        p = state[0];
        q = state[1];
    end

endmodule