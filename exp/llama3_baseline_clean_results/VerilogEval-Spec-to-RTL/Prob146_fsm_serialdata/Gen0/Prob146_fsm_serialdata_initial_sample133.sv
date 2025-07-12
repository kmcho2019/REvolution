module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;

// Enum for states
enum {IDLE, RECEIVING, STOP_BIT_CHECK, WAIT_FOR_STOP} state, next_state;

// Counter for bits received
reg [2:0] bit_count;

always @(*) begin
    case(state)
        IDLE: begin
            if(in == 0) // Start bit detected
                next_state = RECEIVING;
            else
                next_state = IDLE;
        end
        RECEIVING: begin
            if(bit_count == 7) // 8 bits received
                next_state = STOP_BIT_CHECK;
            else
                next_state = RECEIVING;
        end
        STOP_BIT_CHECK: begin
            if(in == 1) // Stop bit is correct
                next_state = IDLE;
            else // Stop bit is incorrect, wait for stop bit
                next_state = WAIT_FOR_STOP;
        end
        WAIT_FOR_STOP: begin
            if(in == 1) // Stop bit detected, go back to IDLE
                next_state = IDLE;
            else
                next_state = WAIT_FOR_STOP;
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        bit_count <= 0;
        out_byte_reg <= 8'b0;
        done_reg <= 0;
    end else begin
        state <= next_state;
        if(next_state == RECEIVING) begin
            out_byte_reg[bit_count] <= in;
            bit_count <= bit_count + 1;
        end else if(next_state == STOP_BIT_CHECK) begin
            if(in == 1) // Stop bit is correct
                done_reg <= 1;
            else
                done_reg <= 0;
        end else if(next_state == IDLE) begin
            done_reg <= 0;
            bit_count <= 0;
        end else if(next_state == WAIT_FOR_STOP) begin
            done_reg <= 0;
        end
    end
end

always @(posedge clk) begin
    if(state == IDLE && next_state == RECEIVING)
        bit_count <= 0;
    if(next_state == STOP_BIT_CHECK && in == 1) begin
        out_byte <= out_byte_reg;
        done <= 1;
    end else begin
        out_byte <= out_byte_reg;
        done <= 0;
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule