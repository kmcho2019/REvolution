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
    reg [1:0] cycle_count;
    reg [2:0] w_history;
    
    // Next state logic
    wire next_state = (reset) ? A : 
                    (state == A) ? (s ? B : A) : 
                    B;
    
    // Cycle counter logic
    wire [1:0] next_cycle_count = (reset || state == A) ? 2'b00 : 
                                 (cycle_count == 2'd2) ? 2'd0 : 
                                 (cycle_count + 1);
    
    // Shift register update
    wire [2:0] next_w_history = (reset || state == A) ? 3'b000 : 
                               {w_history[1:0], w};
    
    // Sequential elements update
    always @(posedge clk) begin
        state <= next_state;
        cycle_count <= next_cycle_count;
        w_history <= next_w_history;
    end
    
    // Output logic
    wire evaluation_flag = (state == B) && (cycle_count == 2'd2);
    wire [1:0] ones_count = w_history[0] + w_history[1] + w_history[2];
    assign z = evaluation_flag && (ones_count == 2'd2);

endmodule