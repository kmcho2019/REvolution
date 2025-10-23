module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State feedback wire
    wire state_B_fb;
    
    // D-flip-flop implementation with async reset
    wire state_B_in = areset ? 1'b0 : (state_B_fb | (~state_B_fb & x));
    reg state_B;
    assign state_B_fb = state_B;
    
    // Output logic (Mealy-type)
    assign z = state_B_fb ? ~x : x;
    
    // Clocked state update
    always @(posedge clk) begin
        state_B <= state_B_in;
    end

endmodule