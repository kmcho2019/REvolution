module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    // State encoding (2 bits for clarity)
    localparam [1:0] OFF = 2'b00;
    localparam [1:0] ON  = 2'b01;

    reg [1:0] state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Combined next state and output logic (Moore machine)
    always @(*) begin
        case (state)
            OFF: begin
                out = 1'b0;
                next_state = (j) ? ON : OFF;
            end
            ON: begin
                out = 1'b1;
                next_state = (k) ? OFF : ON;
            end
            default: begin
                out = 1'b0;
                next_state = OFF;
            end
        endcase
    end

endmodule