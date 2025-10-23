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

    // Sequential logic: state register with synchronous reset and next state computed inline
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            case (state)
                OFF: state <= (j) ? ON : OFF;
                ON:  state <= (k) ? OFF : ON;
                default: state <= OFF;
            endcase
        end
    end

    // Moore output logic: combinationally derived from registered state
    always @(*) begin
        case (state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule