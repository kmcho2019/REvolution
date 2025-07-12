module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Window tracking
    reg [1:0] cycle_count;  // Counts 0,1,2
    reg w1, w2, w3;         // Explicit shift register bits

    // Combinational logic
    wire stay_in_A = (state == A) & ~s;
    wire move_to_B = (state == A) & s;
    wire stay_in_B = (state == B);
    wire next_state = stay_in_A ? A : (move_to_B | stay_in_B) ? B : A;

    wire counter_wrap = (cycle_count == 2'd2);
    wire [1:0] next_count = counter_wrap ? 2'd0 : (cycle_count + 1'b1);
    
    wire ones_count = w1 + w2 + w3;
    wire output_condition = (state == B) & counter_wrap & (ones_count == 2'd2);
    assign z = output_condition;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_count <= 2'd0;
            {w1, w2, w3} <= 3'b000;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update shift register
                w3 <= w2;
                w2 <= w1;
                w1 <= w;
                
                // Update counter
                cycle_count <= next_count;
            end else begin
                // Reset tracking in state A
                cycle_count <= 2'd0;
                {w1, w2, w3} <= 3'b000;
            end
        end
    end

endmodule