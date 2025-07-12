module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;
    
    reg current_state;

    // Combined state transition and register logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_B;
        end else begin
            case (current_state)
                STATE_B: current_state <= in ? STATE_B : STATE_A;
                STATE_A: current_state <= in ? STATE_A : STATE_B;
            endcase
        end
    end

    // Output logic remains combinational
    assign out = (current_state == STATE_B);

endmodule