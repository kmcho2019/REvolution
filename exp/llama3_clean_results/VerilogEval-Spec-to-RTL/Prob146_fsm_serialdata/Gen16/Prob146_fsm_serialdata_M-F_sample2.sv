module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define states for the finite state machine
localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam DATA = 2'b10;

reg [1:0] state;
reg [7:0] byte_reg;
reg [2:0] bit_counter;
reg [7:0] data_reg;

// Sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        byte_reg <= 8'b0;
        bit_counter <= 3'b000;
        data_reg <= 8'b0;
        done <= 0;
    end else begin
        case(state)
            IDLE: begin
                if (!in) begin
                    state <= START;
                    bit_counter <= 3'b000;
                    data_reg <= 8'b0;
                end
            end
            START: begin
                state <= DATA;
                bit_counter <= 3'b001;
                data_reg[0] <= in;
            end
            DATA: begin
                data_reg <= {data_reg[6:0], in};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 3'd8) begin
                    state <= IDLE;
                    if (in) begin
                        byte_reg <= data_reg;
                        done <= 1;
                    end else begin
                        // Wait for stop bit
                        state <= IDLE;
                    end
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
        if (state == IDLE && bit_counter != 3'd8) begin
            done <= 0;
        end
        out_byte <= byte_reg;
    end
end

endmodule