module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // Minimal state encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Shift register for w samples
    reg [2:0] w_history;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b0;
        end else begin
            case (state)
                A: state <= s ? B : A;
                B: w_history <= {w_history[1:0], w};
            endcase
        end
    end

    // Parallel population count using XOR gates
    wire [1:0] pop_count;
    assign pop_count[0] = w_history[0] ^ w_history[1] ^ w_history[2];
    assign pop_count[1] = (w_history[0] & w_history[1]) | 
                         (w_history[0] & w_history[2]) | 
                         (w_history[1] & w_history[2]);

    // Output logic - check when shift register is full
    assign z = (state == B) && (&w_history[2:1]) && (pop_count == 2'b10);

endmodule