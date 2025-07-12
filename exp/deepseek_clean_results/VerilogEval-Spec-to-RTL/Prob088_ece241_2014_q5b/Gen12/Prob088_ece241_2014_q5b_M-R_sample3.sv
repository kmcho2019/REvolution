module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Explicit one-hot state encoding (2 bits)
    localparam STATE_A = 2'b01;
    localparam STATE_B = 2'b10;
    
    reg [1:0] state;  // One-hot state register

    // Next state logic (combinational)
    wire [1:0] next_state;
    assign next_state = areset ? STATE_A :  // Async reset
                      (state == STATE_A) ? (x ? STATE_B : STATE_A) :
                      STATE_B;  // Stay in B once entered

    // Output logic - Mealy type (depends on state and input)
    assign z = (state == STATE_A) ? x : ~x;

    // State update (sequential)
    always @(posedge clk or posedge areset) begin
        state <= next_state;
    end

endmodule