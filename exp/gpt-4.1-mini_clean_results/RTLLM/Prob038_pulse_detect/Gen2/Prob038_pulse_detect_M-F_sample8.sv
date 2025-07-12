module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding using localparam
    localparam IDLE = 2'd0;  // Waiting for data_in to go high (start of pulse)
    localparam HIGH = 2'd1;  // data_in is high, pulse is ongoing
    localparam LOW  = 2'd2;  // data_in returned to low, pulse ended

    reg [1:0] state, next_state;

    // Combinational block: Next state logic
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

    // Sequential block: State update and output generation
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Assert data_out only when state indicates pulse end (LOW)
            data_out <= (state == LOW) ? 1'b1 : 1'b0;
        end
    end

endmodule