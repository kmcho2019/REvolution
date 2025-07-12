module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;
    
    // State register
    reg state;
    wire next_state = reset ? A : (state == A) ? (s ? B : A) : B;
    
    // Window tracking
    reg [1:0] cycle_count;
    wire [1:0] next_cycle_count = reset ? 2'b00 : 
                                (state == B) ? ((cycle_count == 2'd2) ? 2'd0 : (cycle_count + 1'b1)) : 
                                2'b00;
    
    reg [2:0] w_history;
    wire [2:0] next_w_history = (reset || state == A) ? 3'b000 : {w_history[1:0], w};
    
    // Output logic - optimized using LUT instead of adder
    wire z_condition;
    assign z_condition = (w_history == 3'b011) || (w_history == 3'b101) || 
                         (w_history == 3'b110) || (w_history == 3'b111);
    assign z = (state == B) && (cycle_count == 2'd0) && z_condition;
    
    // Sequential elements updated on clock edge
    always @(posedge clk) begin
        state <= next_state;
        cycle_count <= next_cycle_count;
        if (state == B && !reset) begin
            w_history <= {w_history[1:0], w};
        end else begin
            w_history <= 3'b000;
        end
    end

endmodule