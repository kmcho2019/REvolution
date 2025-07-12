module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM states
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam STOP_CHECK = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]}; // shift in at LSB
                    bit_count <= bit_count + 1'b1;
                end

                STOP_CHECK: begin
                    // No shift or count change
                end

                DONE: begin
                    done <= 1'b1; // pulse done one cycle
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = RECEIVE;
            end

            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = DONE;     // Valid stop bit
                else
                    next_state = STOP_CHECK; // Wait until stop bit (1)
            end

            DONE: begin
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule