module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE = 2'd0;  // Waiting for rising edge
    localparam HIGH = 2'd1;  // data_in went high
    localparam LOW  = 2'd2;  // data_in returned to low after high

    reg [1:0] state, next_state;
    reg data_in_d;  // Delayed data_in to stabilize transitions

    // Synchronize data_in by registering it
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_in_d <= 1'b0;
        else
            data_in_d <= data_in;
    end

    // FSM next state logic based on delayed input
    always @(*) begin
        case (state)
            IDLE: next_state = (data_in_d) ? HIGH : IDLE;
            HIGH: next_state = (~data_in_d) ? LOW : HIGH;
            LOW:  next_state = (data_in_d) ? HIGH : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // FSM state update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Registered output: pulse detected when transitioning HIGH->LOW (data_in fell)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_out <= 1'b0;
        else if ((state == HIGH) && (~data_in_d))
            data_out <= 1'b1;
        else
            data_out <= 1'b0;
    end

endmodule