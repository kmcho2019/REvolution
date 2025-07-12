module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding with output bit (z) as MSB
    // Format: {z, state_id[1:0]}
    localparam [2:0] 
        A = 3'b000,  // z=0
        B = 3'b001,  // z=0
        C = 3'b001,  // z=0 (same as B but different transitions)
        D = 3'b010,  // z=0
        E = 3'b110,  // z=1
        F = 3'b110;  // z=1 (same as E but different transitions)

    reg [2:0] current_state;

    // Parallel next state computation for both w cases
    wire [2:0] next_state_w0, next_state_w1;
    
    // Next state when w=0
    assign next_state_w0 = 
        (current_state == A) ? B :
        (current_state == B) ? C :
        (current_state == C) ? E :
        (current_state == D) ? F :
        (current_state == E) ? E :
        (current_state == F) ? C : A;
    
    // Next state when w=1
    assign next_state_w1 = 
        (current_state == A) ? A :
        (current_state == B) ? D :
        (current_state == C) ? D :
        (current_state == D) ? A :
        (current_state == E) ? D :
        (current_state == F) ? D : A;

    // Final next state selection
    wire [2:0] next_state = w ? next_state_w1 : next_state_w0;

    // State register
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output is directly from state encoding
    assign z = current_state[2];

endmodule