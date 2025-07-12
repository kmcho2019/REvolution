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
    wire w_history_en = (state == B) && !reset;
    wire [2:0] next_w_history = reset ? 3'b000 : 
                               w_history_en ? {w_history[1:0], w} : 
                               w_history;
    
    // Optimized output logic - detects exactly 2 ones in 3 bits
    wire exactly_two_ones = (w_history[0] & w_history[1] & ~w_history[2]) |
                          (w_history[0] & ~w_history[1] & w_history[2]) |
                          (~w_history[0] & w_history[1] & w_history[2]);
    assign z = (state == B) && (cycle_count == 2'd0) && exactly_two_ones;
    
    // Sequential elements updated on clock edge
    always @(posedge clk) begin
        state <= next_state;
        cycle_count <= next_cycle_count;
        if (w_history_en) begin
            w_history <= {w_history[1:0], w};
        end
    end

endmodule