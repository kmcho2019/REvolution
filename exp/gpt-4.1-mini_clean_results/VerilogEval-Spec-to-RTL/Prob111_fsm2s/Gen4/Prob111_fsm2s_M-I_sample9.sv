module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0,
               ON  = 1'b1;

    reg state;

    // Sequential logic: state register with synchronous reset and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            case (state)
                OFF: state <= (j) ? ON : OFF;
                ON:  state <= (k) ? OFF : ON;
                default: state <= OFF;
            endcase
            out <= state;  // Moore output from current state
        end
    end

endmodule