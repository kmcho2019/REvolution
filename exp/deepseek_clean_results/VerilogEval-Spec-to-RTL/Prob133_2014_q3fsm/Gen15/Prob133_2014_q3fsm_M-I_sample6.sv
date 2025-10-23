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

    // Phase tracking and popcount counter
    reg phase;  // 0 when evaluating, 1/2 when counting
    reg [1:0] count;  // Count of 1's in current window

    // Next state logic
    wire next_state = reset ? A : (state == A ? (s ? B : A) : B);
    
    // Next phase and count logic
    wire next_phase = reset ? 1'b0 : 
                     (state == B) ? (phase ? 1'b0 : 1'b1) : 1'b0;
    
    wire [1:0] next_count = reset ? 2'b0 : 
                          (state == B) ? 
                              (phase ? (w ? count + 1'b1 : count) : 2'b0) : 
                          2'b0;

    // Output logic - evaluate when phase transitions from 1 to 0
    assign z = (state == B) && (next_phase == 1'b0) && (phase == 1'b1) && (count == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        state <= next_state;
        phase <= next_phase;
        count <= next_count;
    end

endmodule