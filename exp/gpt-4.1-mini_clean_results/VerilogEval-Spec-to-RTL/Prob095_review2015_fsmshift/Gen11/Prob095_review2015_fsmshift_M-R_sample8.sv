module TopModule (
    input  wire clk,
    input  wire reset,      // synchronous active-high reset
    output wire shift_ena
);

    // State encoding (1-bit)
    localparam IDLE   = 1'b0;
    localparam ENABLE = 1'b1;

    reg state, next_state;
    reg [2:0] count;

    // State and counter update (synchronous)
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            count <= 3'd4;
        end else begin
            state <= next_state;
            if (state == ENABLE && count != 0) begin
                count <= count - 1;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE:   next_state = IDLE;  // remain idle forever
            ENABLE: next_state = (count == 1) ? IDLE : ENABLE;
            default: next_state = IDLE;
        endcase
    end

    // Output assignment: shift_ena is asserted in ENABLE state
    assign shift_ena = (state == ENABLE);

endmodule