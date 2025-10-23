module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    // State definitions
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;
    
    reg current_state;
    reg next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State register and output register (sequential)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= OFF;
            out <= 1'b0;
        end else begin
            current_state <= next_state;
            out <= (next_state == ON);
        end
    end

endmodule