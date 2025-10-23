module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    reg state;       // 0=A, 1=B
    reg [2:0] w_reg; // Stores last 3 w values

    // z is high when in state B and exactly two 1's in last 3 cycles
    assign z = state && (w_reg[0] + w_reg[1] + w_reg[2] == 2);

    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            w_reg <= 0;
        end else begin
            case (state)
                0: if (s) begin // State A -> B transition
                    state <= 1;
                    w_reg <= 0;
                end
                
                1: begin // State B
                    w_reg <= {w_reg[1:0], w}; // Shift in new w value
                end
            endcase
        end
    end

endmodule