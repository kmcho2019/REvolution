module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding using localparams for clarity
    localparam IDLE = 2'd0;
    localparam HIGH = 2'd1;
    localparam LOW  = 2'd2;

    reg [1:0] state, next_state;

    // Next state logic (combinational)
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

    // Sequential logic: state update and pulse detection output
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Assert data_out only for one cycle when pulse ends (transition from HIGH to LOW)
            if (state == HIGH && next_state == LOW)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule