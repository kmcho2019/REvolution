module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    reg state; // 0: IDLE, 1: COUNTING
    
    // Next state and counter logic
    wire next_state;
    wire [9:0] next_counter;
    
    assign next_state = (load || (state && (counter != 0))) ? 1'b1 : 1'b0;
    assign next_counter = load ? data : 
                        (state && (counter != 0)) ? counter - 1 : 
                        10'b0;

    // Single D flip-flop for both state and counter
    always @(posedge clk) begin
        state <= next_state;
        counter <= next_counter;
    end

    // Terminal count is when we're in IDLE state
    assign tc = ~state;

endmodule