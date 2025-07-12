module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;
    
    reg [2:0] w_history;  // Stores last 3 w values
    
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_history <= 3'b0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        w_history <= 3'b0;
                    end
                end
                B: begin
                    w_history <= {w_history[1:0], w};
                end
            endcase
        end
    end
    
    // z is 1 if exactly two of the last three w's were 1
    assign z = (state == B) && 
               ((w_history[0] + w_history[1] + w_history[2]) == 2);

endmodule