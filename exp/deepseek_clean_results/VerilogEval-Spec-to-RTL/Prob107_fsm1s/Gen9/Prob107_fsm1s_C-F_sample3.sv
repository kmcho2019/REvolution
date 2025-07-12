module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Named state parameters for readability
    localparam STATE_B = 1'b0;
    localparam STATE_A = 1'b1;
    
    reg state;

    // Single always block for optimal timing
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;
        end else begin
            case (state)
                STATE_B: state <= in ? STATE_B : STATE_A;
                STATE_A: state <= in ? STATE_A : STATE_B;
            endcase
        end
    end

    // Direct state-based output assignment
    assign out = (state == STATE_B);

endmodule