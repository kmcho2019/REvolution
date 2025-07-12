module TopModule (
    input clk,
    input reset,
    output shift_ena
);
    // State encoding
    localparam IDLE = 1'b0;
    localparam ACTIVE = 1'b1;

    reg state, next_state;
    reg [1:0] count; // 2-bit counter for 4 cycles

    // State and counter update
    always @(posedge clk) begin
        if (reset) begin
            state <= ACTIVE;
            count <= 2'd3;  // 4 cycles counting down from 3 to 0
        end else begin
            state <= next_state;
            if (state == ACTIVE)
                count <= count - 1;
            else
                count <= count;
        end
    end

    // Next state logic combinational
    always @(*) begin
        case(state)
            ACTIVE: next_state = (count == 0) ? IDLE : ACTIVE;
            IDLE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign shift_ena = (state == ACTIVE);

endmodule