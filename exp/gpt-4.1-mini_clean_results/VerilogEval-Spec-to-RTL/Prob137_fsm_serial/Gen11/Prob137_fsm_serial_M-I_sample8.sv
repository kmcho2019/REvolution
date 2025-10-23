module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot state encoding
    localparam
        IDLE  = 4'b0001,
        DATA  = 4'b0010,
        STOP  = 4'b0100,
        ERROR = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;      // Counts 0..7
    reg [7:0] shift_reg;

    // Clock enables
    wire data_en = (state == DATA);
    wire done_pulse;

    // Sequential logic: state register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter with clock enable in DATA state only
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (data_en)
            bit_count <= bit_count + 3'd1;
        else if (state != DATA)
            bit_count <= 3'd0; // Clear outside DATA
    end

    // Shift register with clock enable in DATA state only; shift left with in at LSB
    // This shifts in LSB first, data bit at LSB side after 8 shifts
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (data_en)
            shift_reg <= {in, shift_reg[7:1]};
        else if (state != DATA)
            shift_reg <= 8'd0;
    end

    // done is asserted for one cycle when valid stop bit detected in STOP state
    always @(posedge clk) begin
        if (reset)
            done <= 1'b0;
        else
            done <= (state == STOP) && (in == 1'b1);
    end

    // Next state logic with one-hot encoding (only one bit set at a time)
    always @(*) begin
        next_state = 4'b0000;
        case (1'b1)
            // IDLE state
            state[0]: begin
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end

            // DATA state
            state[1]: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            // STOP state
            state[2]: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            // ERROR state
            state[3]: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end

            default: next_state = IDLE; // Safe default
        endcase
    end

endmodule