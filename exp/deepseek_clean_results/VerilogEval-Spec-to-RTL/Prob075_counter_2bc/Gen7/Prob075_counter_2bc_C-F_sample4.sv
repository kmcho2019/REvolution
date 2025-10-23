module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    // State register with explicit encoding
    reg [1:0] current_state;
    
    // Next state calculation
    wire [1:0] next_state;
    assign next_state = 
        train_valid ? 
            (train_taken ? 
                (current_state == 2'b11 ? 2'b11 : current_state + 1) :
                (current_state == 2'b00 ? 2'b00 : current_state - 1)) :
        current_state;

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= 2'b01;  // Reset to weakly not-taken
        else
            current_state <= next_state;
    end

    assign state = current_state;

endmodule