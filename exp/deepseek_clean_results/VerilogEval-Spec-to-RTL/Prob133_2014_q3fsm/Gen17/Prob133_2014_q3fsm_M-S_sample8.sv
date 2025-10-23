module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg [1:0] state;
    localparam STATE_A = 2'b00;
    localparam STATE_B = 2'b01;
    localparam STATE_C = 2'b10;

    // Track last 2 w samples
    reg [1:0] w_samples;

    // Next state and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            w_samples <= 2'b00;
        end else begin
            case (state)
                STATE_A: begin
                    w_samples <= 2'b00;
                    state <= s ? STATE_B : STATE_A;
                end
                STATE_B: begin
                    w_samples <= {w_samples[0], w};
                    state <= STATE_C;
                end
                STATE_C: begin
                    w_samples <= {w_samples[0], w};
                    state <= STATE_B;
                end
            endcase
        end
    end

    // Output logic: exactly two 1's in last 3 cycles (current w + w_samples)
    assign z = (state == STATE_B) && 
               ((w + w_samples[0] + w_samples[1]) == 2);

endmodule