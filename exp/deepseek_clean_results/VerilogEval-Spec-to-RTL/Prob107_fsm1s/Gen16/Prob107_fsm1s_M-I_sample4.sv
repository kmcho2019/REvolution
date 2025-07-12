module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;
    
    reg state;

    // Combined state transition and update logic
    always @(posedge clk) begin
        if (reset)
            state <= STATE_B;
        else begin
            case (state)
                STATE_B: state <= in ? STATE_B : STATE_A;
                STATE_A: state <= in ? STATE_A : STATE_B;
                default: state <= STATE_B;
            endcase
        end
    end

    // Output logic remains combinational
    assign out = (state == STATE_B);

endmodule