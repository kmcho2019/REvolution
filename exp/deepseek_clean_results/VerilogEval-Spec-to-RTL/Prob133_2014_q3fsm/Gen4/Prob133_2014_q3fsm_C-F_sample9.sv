module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    reg [1:0] cycle_count;  // Modulo-3 counter (0-2)
    reg [2:0] w_history;    // Shift register for w values
    reg evaluation_flag;    // Evaluation trigger
    
    // Combinational output logic
    wire [1:0] ones_count = w_history[0] + w_history[1] + w_history[2];
    assign z = (state == B) && evaluation_flag && (ones_count == 2'd2);
    
    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_history <= 3'b000;
            evaluation_flag <= 1'b0;
        end else begin
            evaluation_flag <= 1'b0;  // Default clear
            
            case (state)
                A: begin
                    if (s) begin
                        state <= B;
                        cycle_count <= 2'b00;
                        w_history <= 3'b000;
                    end
                end
                
                B: begin
                    // Update shift register only in state B
                    w_history <= {w_history[1:0], w};
                    
                    // Modulo-3 counter
                    cycle_count <= (cycle_count == 2'd2) ? 2'd0 : (cycle_count + 1);
                    
                    // Set evaluation flag at window end
                    if (cycle_count == 2'd2) begin
                        evaluation_flag <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule