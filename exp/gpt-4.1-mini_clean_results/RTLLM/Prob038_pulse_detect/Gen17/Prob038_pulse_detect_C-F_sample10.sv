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
    reg       data_in_reg;

    // Synchronize data_in to clk domain to avoid glitches and metastability
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_in_reg <= 1'b0;
        else
            data_in_reg <= data_in;
    end

    // Next state combinational logic based on registered input
    always @(*) begin
        case(state)
            IDLE: begin
                if (data_in_reg)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (!data_in_reg)
                    next_state = LOW;
                else
                    next_state = HIGH;
            end
            LOW: begin
                if (data_in_reg)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: update state and output synchronously
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;

            // Assert data_out for one cycle at the falling edge of data_in_reg when in HIGH state
            // i.e., when current state is HIGH and data_in_reg drops to 0 -> pulse detected
            if ((state == HIGH) && (data_in_reg == 1'b0))
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule