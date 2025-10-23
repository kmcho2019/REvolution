module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;

    reg state;
    reg next_state;
    wire output_bit;

    // Next state combinational logic
    always @(*) begin
        case(state)
            COPY:   next_state = (x == 1'b1) ? INVERT : COPY;
            INVERT: next_state = INVERT;
            default: next_state = COPY;
        endcase
    end

    // Output bit combinational logic based on current state (Moore output)
    assign output_bit = (state == COPY) ? 1'b0 : 1'b1;

    // State and output register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= x ^ output_bit;  // Moore output depends only on state (output_bit) and registered at clock edge
        end
    end

endmodule