module TopModule(
    input        clk,
    input        in,
    input        reset,
    output reg [7:0] out_byte,
    output reg       done
);

// States definition
localparam IDLE    = 2'd0;
localparam RECEIVE = 2'd1;
localparam STOP    = 2'd2;

reg [1:0] state, next_state;
reg [2:0] bit_count;    // 0 to 7 for data bits count
reg [7:0] shift_reg;

// Sequential logic: state, registers, outputs update
always @(posedge clk) begin
    if (reset) begin
        state     <= IDLE;
        bit_count <= 3'd0;
        shift_reg <= 8'd0;
        out_byte  <= 8'd0;
        done      <= 1'b0;
    end else begin
        state <= next_state;
        done  <= 1'b0;  // default done is 0, asserted only on stop bit valid

        case (state)
            IDLE: begin
                bit_count <= 3'd0;
                shift_reg <= 8'd0;
            end

            RECEIVE: begin
                // Shift left and insert input bit at LSB for LSB-first reception
                shift_reg <= {shift_reg[6:0], in};
                bit_count <= bit_count + 3'd1;
            end

            STOP: begin
                // If valid stop bit, latch output byte and assert done for one cycle
                if (in == 1'b1) begin
                    out_byte <= shift_reg;
                    done <= 1'b1;
                end
                // else remain in STOP state until stop bit = 1
            end

            default: begin
                // Safety: treat as IDLE
                bit_count <= 3'd0;
                shift_reg <= 8'd0;
            end
        endcase
    end
end

// Next state logic combinational
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
            if (bit_count == 3'd7) // After receiving 8 bits (bit_count from 0 to 7)
                next_state = STOP;
            else
                next_state = RECEIVE;
        end

        STOP: begin
            if (in == 1'b1)
                next_state = IDLE;  // Valid stop bit, go back to idle for next byte
            else
                next_state = STOP;  // Wait here until stop bit is 1
        end

        default: next_state = IDLE;
    endcase
end

endmodule