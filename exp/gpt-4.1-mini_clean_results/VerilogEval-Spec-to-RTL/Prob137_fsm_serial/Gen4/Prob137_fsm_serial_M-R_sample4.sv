module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);
    // State encoding
    localparam IDLE      = 2'b00;
    localparam DATA      = 2'b01;
    localparam STOP      = 2'b10;
    localparam WAIT_STOP = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] bit_count;
    reg bit_count_en;

    // Next state and output logic (combinational)
    always @(*) begin
        next_state = state;
        bit_count_en = 1'b0;
        done = 1'b0;

        case(state)
            IDLE: begin
                bit_count_en = 1'b0;
                if (in == 1'b0)
                    next_state = DATA; // start bit detected
                else
                    next_state = IDLE;
            end

            DATA: begin
                bit_count_en = 1'b1;
                if (bit_count == 4'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                bit_count_en = 1'b0;
                if (in == 1'b1) begin
                    done = 1'b1; // valid stop bit, pulse done
                    next_state = IDLE;
                end else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                bit_count_en = 1'b0;
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: begin
                bit_count_en = 1'b0;
                next_state = IDLE;
            end
        endcase
    end

    // State and bit counter sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 4'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            if (bit_count_en) begin
                bit_count <= bit_count + 1'b1;
            end else begin
                bit_count <= 4'd0;
            end
            // done is driven combinationally above and registered implicitly by output reg;
            // However, to keep done synchronous and one cycle, assign in combinational always and register done here:
            // But since done is assigned in combinational block, assign here:
            done <= done;
        end
    end

endmodule