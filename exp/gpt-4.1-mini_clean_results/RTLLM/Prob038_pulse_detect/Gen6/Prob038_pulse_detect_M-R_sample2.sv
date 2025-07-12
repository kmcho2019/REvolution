module pulse_detect (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

    reg [1:0] state, next_state;

    // State encoding
    localparam WAIT_ZERO = 2'b00;
    localparam WAIT_ONE  = 2'b01;
    localparam WAIT_FALL = 2'b10;

    // Sequential state update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= WAIT_ZERO;
        else
            state <= next_state;
    end

    // Combinational next state and output logic
    always @(*) begin
        next_state = state;
        data_out = 1'b0;

        case (state)
            WAIT_ZERO: begin
                if (data_in == 1'b0)
                    next_state = WAIT_ONE;
                else
                    next_state = WAIT_ZERO;
            end
            WAIT_ONE: begin
                if (data_in == 1'b1)
                    next_state = WAIT_FALL;
                else
                    next_state = WAIT_ONE;
            end
            WAIT_FALL: begin
                if (data_in == 1'b0) begin
                    data_out = 1'b1;  // pulse detected at falling edge
                    next_state = WAIT_ZERO;
                end else
                    next_state = WAIT_FALL;
            end
            default: next_state = WAIT_ZERO;
        endcase
    end

endmodule