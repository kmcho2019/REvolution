module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;

// Define the states
localparam IDLE = 4'd0;
localparam START_BIT = 4'd1;
localparam DATA_BITS = 4'd2;
localparam STOP_BIT = 4'd3;
localparam ERROR = 4'd4;

reg [3:0] state_reg;
reg [3:0] state_next;

// Define the data bit counter
reg [2:0] data_bit_counter;
reg [2:0] data_bit_counter_next;

// Define the output byte shift register
reg [7:0] out_byte_shift;
reg [7:0] out_byte_shift_next;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        data_bit_counter <= 0;
        out_byte_shift <= 8'b0;
    end else begin
        state_reg <= state_next;
        data_bit_counter <= data_bit_counter_next;
        out_byte_shift <= out_byte_shift_next;
    end
end

always @(*) begin
    state_next = state_reg;
    data_bit_counter_next = data_bit_counter;
    out_byte_shift_next = out_byte_shift;

    done_reg = 0;

    case (state_reg)
        IDLE: begin
            if (!in) begin
                state_next = START_BIT;
            end
        end

        START_BIT: begin
            state_next = DATA_BITS;
            data_bit_counter_next = 0;
        end

        DATA_BITS: begin
            out_byte_shift_next = {out_byte_shift[6:0], in};
            data_bit_counter_next = data_bit_counter + 1;

            if (data_bit_counter == 7) begin
                state_next = STOP_BIT;
            end
        end

        STOP_BIT: begin
            if (in) begin
                state_next = IDLE;
                out_byte_reg = out_byte_shift;
                done_reg = 1;
            end else begin
                state_next = ERROR;
            end
        end

        ERROR: begin
            if (in) begin
                state_next = IDLE;
            end
        end
    endcase
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule