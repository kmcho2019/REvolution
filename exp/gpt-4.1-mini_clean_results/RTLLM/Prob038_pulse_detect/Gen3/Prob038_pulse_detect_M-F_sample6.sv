module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // Binary encoding for FSM states
    localparam IDLE      = 2'b00; // Waiting for data_in == 1
    localparam WAIT_HIGH = 2'b01; // Detected rising edge (data_in==1), expect still 1 next cycle
    localparam WAIT_LOW  = 2'b10; // Confirming falling edge, waiting for data_in == 0

    reg [1:0] state, next_state;
    reg       data_in_d; // Registered version of data_in for timing and output logic

    // Register data_in to stabilize it for output generation and state decisions
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            data_in_d <= 1'b0;
        else
            data_in_d <= data_in;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = WAIT_HIGH;
                else
                    next_state = IDLE;
            end

            WAIT_HIGH: begin
                if (data_in == 1'b1)
                    next_state = WAIT_LOW;
                else
                    next_state = IDLE;
            end

            WAIT_LOW: begin
                if (data_in == 1'b0)
                    next_state = IDLE;
                else
                    next_state = WAIT_LOW;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state and data_out generation
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;

            // data_out asserted for one cycle at pulse end:
            // pulse end = transition out of WAIT_LOW when data_in transitions to 0
            // Use registered data_in_d for timing stable output
            if ((state == WAIT_LOW) && (data_in_d == 1'b0))
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule