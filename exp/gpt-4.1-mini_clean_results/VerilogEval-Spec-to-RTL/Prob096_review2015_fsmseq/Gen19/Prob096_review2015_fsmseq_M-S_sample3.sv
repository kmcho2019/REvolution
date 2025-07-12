module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding (2-bit) for prefix matching of "1101"
    // S0: no match
    // S1: matched '1'
    // S2: matched "11"
    // S3: matched "110"
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            2'd0: next_state = data ? 2'd1 : 2'd0;
            2'd1: next_state = data ? 2'd2 : 2'd0;
            2'd2: next_state = data ? 2'd2 : 2'd3;
            2'd3: next_state = data ? 2'd1 : 2'd0;
            default: next_state = 2'd0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'd0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            // Latch start_shifting once sequence "1101" detected:
            // This happens when current state is 3 and data=1 input arrives (detected)
            if (state == 2'd3 && data)
                start_shifting <= 1'b1;
        end
    end

endmodule