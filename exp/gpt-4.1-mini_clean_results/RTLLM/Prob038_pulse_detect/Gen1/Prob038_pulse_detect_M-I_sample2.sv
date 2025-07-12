module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding with localparam for better portability
    localparam IDLE = 2'd0;  // waiting for data_in=1
    localparam HIGH = 2'd1;  // data_in=1 detected
    localparam LOW  = 2'd2;  // data_in=0 after high, pulse end

    reg [1:0] state, next_state;

    // Next state logic combinational
    always @(*) begin
        case(state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end

            HIGH: begin
                if (~data_in)
                    next_state = LOW;
                else
                    next_state = HIGH;
            end

            LOW: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update and data_out generation
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // data_out is asserted only on the cycle when state is LOW (pulse end)
            data_out <= (state == LOW) ? 1'b1 : 1'b0;
        end
    end

endmodule