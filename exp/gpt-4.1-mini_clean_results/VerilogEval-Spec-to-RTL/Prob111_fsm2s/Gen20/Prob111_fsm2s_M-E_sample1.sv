module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire j,
    input  wire k,
    output reg  out
);

    // State encoding using localparams
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State and output update (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out   <= 1'b0;
        end else begin
            state <= next_state;
            out   <= next_state;  // output depends only on state (Moore)
        end
    end

endmodule