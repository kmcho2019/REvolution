module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [2:0] state;  // one-hot: state[0]=idle, state[1]=byte1, state[2]=byte2

    // Combinational done signal
    assign done = state[2];

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b001;  // Reset to idle state
        end else begin
            case (1'b1)
                state[0]: // idle
                    if (in[3]) state <= 3'b010;  // move to byte1 state
                state[1]: // byte1
                    state <= 3'b100;             // move to byte2 state
                state[2]: // byte2
                    if (in[3]) state <= 3'b010;  // start new message
                    else state <= 3'b001;         // return to idle
                default:
                    state <= 3'b001;             // handle undefined states
            endcase
        end
    end

endmodule