module TopModule (
    input clk,
    input L,
    input q_in,     // Feedback input (varies by bit position)
    input r_in,     // Load value
    output Q
);

    wire next_state = L ? r_in : q_in;
    
    // D-flipflop
    reg state;
    always @(posedge clk) begin
        state <= next_state;
    end
    
    assign Q = state;

endmodule