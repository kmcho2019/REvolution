module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    // One-hot state encoding
    localparam OFF = 2'b01;
    localparam ON  = 2'b10;
    
    reg [1:0] state, next_state;
    reg out_reg;
    
    // Combinational next state logic
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end
    
    // Sequential state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
            out_reg <= 1'b0;
        end else begin
            state <= next_state;
            out_reg <= (next_state == ON);
        end
    end
    
    assign out = out_reg;
endmodule