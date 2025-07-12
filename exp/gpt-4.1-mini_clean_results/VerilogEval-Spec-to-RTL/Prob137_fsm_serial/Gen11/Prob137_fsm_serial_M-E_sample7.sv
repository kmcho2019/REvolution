module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot encoded states (4 states)
    localparam IDLE  = 4'b0001;
    localparam START = 4'b0010;
    localparam DATA  = 4'b0100;
    localparam STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;    // 3-bit counter for data bits [0..7]
    reg [7:0] shift_reg;    // 8-bit shift register for data bits

    // Sequential logic: state, counter, shift register, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // Default no pulse

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                START: begin
                    // Confirm start bit held low, no data shift yet
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                DATA: begin
                    // Shift left: input bit into LSB to capture LSB-first order
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    // If stop bit (in) is 1, output done pulse
                    if (in == 1'b1)
                        done <= 1'b1;
                    // bit_count reset at STOP or stable
                    bit_count <= 3'd0;
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Combinational next-state logic
    always @(*) begin
        next_state = state;

        case (state)
            IDLE: begin
                // Wait for start bit low to transition to START
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end

            START: begin
                // Confirm line remains low for a full cycle; if still low, go to DATA
                // Else go back to IDLE (false start)
                if (in == 1'b0)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end

            DATA: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                // Wait until stop bit (1) received
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = STOP; // Hold until stop bit detected
            end

            default: next_state = IDLE;
        endcase
    end

endmodule