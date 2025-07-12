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
    reg [2:0] w_window;
    
    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;
    
    // Cycle counter logic
    wire [1:0] next_cycle_count = (state == B) ? 
                                 ((cycle_count == 2'd2) ? 2'd0 : (cycle_count + 1)) : 
                                 2'd0;
    
    // Window shift logic
    wire [2:0] next_w_window = (state == B) ? {w_window[1:0], w} : 3'b000;
    
    // Evaluation flag (combinational)
    wire evaluate = (state == B) && (cycle_count == 2'd2);
    
    // Output logic
    wire [1:0] ones_count = w_window[0] + w_window[1] + w_window[2];
    assign z = evaluate && (ones_count == 2'd2);
    
    // Sequential elements
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'b00;
            w_window <= 3'b000;
        end else begin
            state <= next_state;
            cycle_count <= next_cycle_count;
            w_window <= next_w_window;
        end
    end

endmodule