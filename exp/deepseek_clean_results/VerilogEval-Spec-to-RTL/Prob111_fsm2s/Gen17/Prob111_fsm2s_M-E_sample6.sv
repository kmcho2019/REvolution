module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // One-hot state encoding (even though we only need 2 states)
    localparam [1:0] OFF = 2'b01;
    localparam [1:0] ON  = 2'b10;
    
    reg [1:0] state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic (combinational)
    assign out = (state == ON);

endmodule