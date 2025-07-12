module pulse_detect (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output wire data_out
);

    // Define states (one-hot encoding)
    localparam IDLE      = 3'b001; // Waiting for first 0
    localparam WAIT_HIGH = 3'b010; // After detecting 0, waiting for 1
    localparam WAIT_LOW  = 3'b100; // After detecting 1, waiting for 0 to complete pulse

    reg [2:0] state, next_state;
    reg pulse_detected;

    // Sequential state update and pulse_detected generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            pulse_detected <= 1'b0;
        end else begin
            state <= next_state;
            pulse_detected <= 1'b0; // default, pulse_detected asserted only when pulse completes
            if (state == WAIT_LOW && data_in == 1'b0)
                pulse_detected <= 1'b1;
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = (data_in == 1'b0) ? WAIT_HIGH : IDLE;
            WAIT_HIGH: 
                next_state = (data_in == 1'b1) ? WAIT_LOW : 
                             (data_in == 1'b0) ? WAIT_HIGH : IDLE;
            WAIT_LOW: 
                next_state = (data_in == 1'b0) ? IDLE : WAIT_LOW;
            default: 
                next_state = IDLE;
        endcase
    end

    // Output pulse_detected registered as data_out
    assign data_out = pulse_detected;

endmodule