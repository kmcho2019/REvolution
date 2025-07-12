module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding using localparams for better portability
    localparam IDLE = 2'd0;
    localparam HIGH = 2'd1;
    localparam LOW  = 2'd2;

    reg [1:0] state, next_state;

    // Next state logic
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

    // Sequential logic: state update and output generation
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Output pulse detection only when entering LOW state (pulse end)
            if (next_state == LOW && state == HIGH)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule