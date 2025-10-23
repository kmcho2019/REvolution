module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM states
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Shift enable active only in RECEIVE state to reduce toggling outside it
    wire shift_en = (state == RECEIVE);

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: 
                next_state = (in == 1'b0) ? RECEIVE : IDLE;

            RECEIVE: 
                next_state = (bit_count == 3'd7) ? CHECK_STOP : RECEIVE;

            CHECK_STOP: 
                next_state = (in == 1'b1) ? IDLE : WAIT_STOP;

            WAIT_STOP: 
                next_state = (in == 1'b1) ? IDLE : WAIT_STOP;

            default: 
                next_state = IDLE;
        endcase
    end

    // Sequential logic: state, bit_count, shift_reg, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // Default done to zero

            if (state == IDLE) begin
                bit_count <= 3'd0;
                shift_reg <= 8'd0;
            end

            // Shift register and counter update only in RECEIVE state to reduce toggling
            if (shift_en) begin
                // Shift right by 1, insert new bit at MSB (LSB-first data reception)
                shift_reg <= {in, shift_reg[7:1]};
                bit_count <= bit_count + 1'b1;
            end

            if (state == CHECK_STOP) begin
                if (in == 1'b1) 
                    done <= 1'b1;
                bit_count <= 3'd0;
            end

            if (state == WAIT_STOP) begin
                // Hold counters and shift_reg stable to reduce toggling
                bit_count <= 3'd0;
                shift_reg <= 8'd0;
            end
        end
    end

endmodule