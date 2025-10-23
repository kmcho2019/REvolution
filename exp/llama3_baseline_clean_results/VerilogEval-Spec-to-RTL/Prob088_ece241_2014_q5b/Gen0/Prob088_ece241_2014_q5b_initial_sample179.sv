module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;

// One-hot encoding: 
// State A: 2'b10
// State B: 2'b01

always @(*) begin
    case(current_state)
        2'b10: // State A
            if (x == 0) 
                next_state = 2'b10;
            else 
                next_state = 2'b01;
        2'b01: // State B
            next_state = 2'b01;
        default: 
            next_state = 2'b10; // Reset state
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) 
        current_state <= 2'b10; // Asynchronous reset
    else 
        current_state <= next_state;
end

always @(*) begin
    case(current_state)
        2'b10: // State A
            if (x == 0) 
                z = 0;
            else 
                z = 1;
        2'b01: // State B
            if (x == 0) 
                z = 1;
            else 
                z = 0;
        default: 
            z = 0; // Default output
    endcase
end

endmodule