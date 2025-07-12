module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;
    
    reg [2:0] w_history;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b0;
            z <= 0;
        end else begin
            case (state)
                A: begin
                    if (s) state <= B;
                    w_history <= 3'b0;
                    z <= 0;
                end
                B: begin
                    w_history <= {w_history[1:0], w};
                    // Check at end of each 3-cycle window
                    if (&w_history[1:0]) begin  // Equivalent to phase==2
                        z <= (w_history[0] + w_history[1] + w) == 2;
                    end else begin
                        z <= 0;
                    end
                end
            endcase
        end
    end

endmodule