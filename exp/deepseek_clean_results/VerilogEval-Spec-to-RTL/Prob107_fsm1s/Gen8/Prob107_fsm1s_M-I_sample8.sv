module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions
    localparam STATE_B = 1'b0;
    localparam STATE_A = 1'b1;
    
    reg current_state;
    reg next_state;
    
    // Next state logic (combinational)
    always @(*) begin
        case (current_state)
            STATE_B: next_state = in ? STATE_B : STATE_A;
            STATE_A: next_state = in ? STATE_A : STATE_B;
            default: next_state = STATE_B;
        endcase
    end
    
    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_B;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Output logic (Moore)
    assign out = (current_state == STATE_B);
    
endmodule