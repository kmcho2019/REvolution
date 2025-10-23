module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE = 2'd0;   // Waiting for rising edge (data_in=0)
    localparam HIGH = 2'd1;   // data_in=1 detected
    localparam LOW  = 2'd2;   // data_in=0 after HIGH, pulse end detected

    reg [1:0] state, next_state;

    // Next state combinational logic
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

    // Sequential state update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Combinational output logic: pulse detected at falling edge of data_in from HIGH state
    always @(*) begin
        if ((state == HIGH) && (data_in == 1'b0))
            data_out = 1'b1;
        else
            data_out = 1'b0;
    end

endmodule