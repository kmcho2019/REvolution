module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // 3-bit shift register for w history and implicit cycle counting
    reg [2:0] w_history;

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b000;
        end else begin
            case (state)
                A: state <= s ? B : A;
                B: w_history <= {w_history[1:0], w};
            endcase
        end
    end

    // Output when we have exactly two 1's in the last 3 cycles
    assign z = (state == B) && (w_history == 3'b110 || 
                                w_history == 3'b101 || 
                                w_history == 3'b011);

endmodule