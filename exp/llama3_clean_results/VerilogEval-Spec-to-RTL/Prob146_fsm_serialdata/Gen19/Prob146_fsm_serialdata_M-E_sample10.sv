module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [7:0] shift_reg;
reg [3:0] bit_counter;
reg [1:0] state;

localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam DATA = 2'b10;
localparam STOP = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        shift_reg <= 8'b0;
        bit_counter <= 4'b0000;
        done <= 0;
    end else begin
        case(state)
            IDLE: begin
                if (!in) begin
                    state <= START;
                    shift_reg <= 8'b0;
                    bit_counter <= 4'b0001;
                end
            end
            START: begin
                state <= DATA;
            end
            DATA: begin
                shift_reg <= {shift_reg[6:0], in}; // Shift in the incoming bit
                bit_counter <= bit_counter + 1;
                if (bit_counter == 4'd9) begin
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin // Stop bit received
                    out_byte <= shift_reg;
                    done <= 1;
                    state <= IDLE;
                end else begin
                    state <= STOP; // Wait for the stop bit
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state != STOP || !in) begin
        done <= 0;
    end
end

endmodule