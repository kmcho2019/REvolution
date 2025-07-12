module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // One-hot encoding for states
    localparam IDLE = 3'b001;
    localparam HIGH = 3'b010;
    localparam LOW  = 3'b100;

    reg [2:0] state, next_state;

    // Sequential logic: state and output registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Assert data_out when we just left HIGH state due to data_in=0 (end of pulse)
            // In Moore FSM, output depends only on current state,
            // so data_out is asserted in LOW state only if previous was HIGH and data_in==0.
            // Here, we detect the pulse end by checking current state LOW and previous state HIGH.
            data_out <= (state == HIGH) && (next_state == LOW);
        end
    end

    // Combinational logic: next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (!data_in)
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

endmodule