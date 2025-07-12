module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // States
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    reg [2:0] w_window;
    reg [1:0] counter;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_window <= 3'b0;
            counter <= 2'b0;
            z <= 1'b0;
        end else begin
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        w_window <= {2'b0, w};
                        counter <= 2'd1;
                    end
                    z <= 1'b0;
                end
                
                B: begin
                    // Shift in new w value
                    w_window <= {w_window[1:0], w};
                    
                    // Update counter
                    if (counter == 2'd2) begin
                        counter <= 2'd0;
                        // Set z based on previous window (now in w_window[2:0])
                        z <= ((w_window[0] + w_window[1] + w_window[2]) == 2'd2);
                    end else begin
                        counter <= counter + 1;
                        z <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule