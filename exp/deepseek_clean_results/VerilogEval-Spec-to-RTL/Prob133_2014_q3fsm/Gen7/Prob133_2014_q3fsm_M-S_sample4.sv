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
    reg [1:0] cycle_count;  // 0-2 counter
    reg [2:0] w_history;    // Last 3 w values
    
    // Combinational output logic
    wire [1:0] ones_count = w_history[0] + w_history[1] + w_history[2];
    assign z = (state == B) && (cycle_count == 2'd2) && (ones_count == 2'd2);
    
    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_history <= 3'b000;
        end else begin
            case (state)
                A: if (s) begin
                    state <= B;
                    cycle_count <= 2'b00;
                    w_history <= 3'b000;
                end
                
                B: begin
                    w_history <= {w_history[1:0], w};
                    cycle_count <= (cycle_count == 2'd2) ? 2'd0 : (cycle_count + 1);
                end
            endcase
        end
    end

endmodule