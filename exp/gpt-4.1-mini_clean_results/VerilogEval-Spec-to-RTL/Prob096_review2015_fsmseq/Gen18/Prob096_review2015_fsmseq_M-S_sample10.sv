module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    reg [1:0] state, next_state;

    // State encoding
    // 0: no match
    // 1: matched '1'
    // 2: matched "11"
    // 3: matched "110"

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            start_shifting <= 0;
        end else begin
            state <= next_state;
            if (start_shifting == 0 && state == 3 && data == 1)
                start_shifting <= 1;
        end
    end

    always @(*) begin
        next_state = state; // default hold
        case (state)
            0: next_state = data ? 1 : 0;
            1: next_state = data ? 2 : 0;
            2: next_state = data ? 2 : 3;
            3: next_state = data ? 1 : 0;
        endcase
    end

endmodule