module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire data_out
);

    // State encoding using localparams for clarity
    localparam IDLE = 2'd0;  // Waiting for data_in=1 (pulse start)
    localparam HIGH = 2'd1;  // data_in=1 detected
    localparam LOW  = 2'd2;  // data_in=0 after HIGH, completing pulse

    reg [1:0] state, next_state;

    // Next-state combinational logic
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

    // State update sequential logic with asynchronous active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output combinational logic (Mealy output):
    // Assert data_out for one cycle when in HIGH state and data_in drops low (pulse end)
    assign data_out = (state == HIGH) && (~data_in);

endmodule