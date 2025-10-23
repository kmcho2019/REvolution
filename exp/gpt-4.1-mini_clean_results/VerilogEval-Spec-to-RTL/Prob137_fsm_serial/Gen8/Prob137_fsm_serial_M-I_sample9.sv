module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

    // One-hot state encoding for better timing
    localparam IDLE    = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam ERROR   = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    wire clk_en = (state == RECEIVE);

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end
            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default no pulse unless asserted below

            if (state == IDLE) begin
                bit_count <= 3'd0;
                data_reg <= 8'd0;
            end else if (clk_en) begin
                // Shift in LSB first: insert new bit at MSB, shift right
                data_reg <= {in, data_reg[7:1]};
                bit_count <= bit_count + 1'b1;
            end

            if (state == STOP) begin
                if (in == 1'b1) begin
                    done <= 1'b1; // one-cycle pulse after correct stop bit
                end
            end
            // ERROR state does not change registers
        end
    end

endmodule