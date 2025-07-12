module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding using 2-bit binary encoding
    localparam IDLE = 2'd0;
    localparam HIGH = 2'd1;
    localparam LOW  = 2'd2;

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

    // State register update (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Register data_out to avoid glitches and stabilize output
    // Output is 1 only for one cycle at the falling edge of data_in after HIGH state,
    // i.e., when current state is HIGH and data_in == 0 (pulse end)
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            data_out <= 1'b0;
        else
            data_out <= (state == HIGH) && (data_in == 1'b0);
    end

endmodule