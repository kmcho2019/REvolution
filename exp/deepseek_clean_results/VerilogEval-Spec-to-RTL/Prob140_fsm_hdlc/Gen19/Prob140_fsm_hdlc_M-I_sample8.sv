module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states (s0-s7)
    reg [7:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 8'b00000001;  // s0 (initial state)
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Default outputs
            disc <= 0;
            flag <= 0;
            err <= 0;

            // State transitions
            if (in) begin
                case (1'b1)
                    state[0]: state <= 8'b00000010; // s0->s1
                    state[1]: state <= 8'b00000100; // s1->s2
                    state[2]: state <= 8'b00001000; // s2->s3
                    state[3]: state <= 8'b00010000; // s3->s4
                    state[4]: state <= 8'b00100000; // s4->s5
                    state[5]: state <= 8'b01000000; // s5->s6
                    state[6]: state <= 8'b10000000; // s6->s7 (error)
                    state[7]: state <= 8'b10000000; // s7->s7 (stay in error)
                endcase
            end else begin
                // Check for outputs when seeing a 0
                if (state[5]) disc <= 1;      // 5 ones followed by 0
                if (state[6]) flag <= 1;      // 6 ones followed by 0
                if (state[7]) err <= 1;       // 7+ ones (error)
                state <= 8'b00000001;         // Reset to s0
            end

            // Error condition (7+ consecutive 1s)
            if (state[7]) err <= 1;
        end
    end

endmodule