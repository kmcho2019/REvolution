module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // One-hot state encoding for 3 states
    localparam IDLE      = 3'b001; // Waiting for data_in==1
    localparam WAIT_HIGH = 3'b010; // data_in==1 detected, wait for next cycle still 1
    localparam WAIT_LOW  = 3'b100; // waiting for data_in==0 to confirm pulse end

    reg [2:0] state, next_state;

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

    // Sequential logic for state and output
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;

            // Assert data_out for one cycle at pulse end:
            // pulse end detected when leaving WAIT_LOW state with data_in==0
            if (state == WAIT_LOW && data_in == 1'b0)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule