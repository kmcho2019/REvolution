module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Named state parameters
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;
    
    reg state;

    // State transition with case statement
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

    // Optimal output logic (inversion is most area-efficient)
    assign out = (state == STATE_B);

endmodule