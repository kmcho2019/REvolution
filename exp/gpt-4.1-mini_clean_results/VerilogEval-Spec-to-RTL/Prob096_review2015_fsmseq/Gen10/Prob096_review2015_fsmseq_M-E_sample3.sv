module TopModule (
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

    // State encoding (binary)
    // 0: no match
    // 1: matched '1'
    // 2: matched '11'
    // 3: matched '110'
    // 4: detected '1101' (sticky final)
    reg [2:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case(state)
            3'd0: next_state = data ? 3'd1 : 3'd0;
            3'd1: next_state = data ? 3'd2 : 3'd0;
            3'd2: next_state = data ? 3'd2 : 3'd3;
            3'd3: next_state = data ? 3'd4 : 3'd0;
            3'd4: next_state = 3'd4; // sticky detected state
            default: next_state = 3'd0;
        endcase
    end

    // State and output registers, synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
            start_shifting <= 1'b0;
        end else begin
            state <= next_state;
            start_shifting <= (next_state == 3'd4);
        end
    end

endmodule