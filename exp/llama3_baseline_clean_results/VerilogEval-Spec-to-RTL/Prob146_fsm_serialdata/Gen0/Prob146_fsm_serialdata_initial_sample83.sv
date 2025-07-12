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
enum logic [2:0] {IDLE, START_BIT, DATA_BITS, STOP_BIT, STOP_BIT_ERROR} state, next_state;

// Initialize the state
initial state = IDLE;

// Define the counter for data bits
reg [2:0] data_bit_counter;

// Define the register for the received data byte
reg [7:0] data_byte;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 0;
        out_byte_reg <= 0;
        data_bit_counter <= 0;
        data_byte <= 0;
    end else begin
        state <= next_state;
        done_reg <= 0;

        case (state)
            IDLE: begin
                if (in == 0) begin // Start bit detected
                    next_state <= START_BIT;
                end else begin
                    next_state <= IDLE;
                end
            end

            START_BIT: begin
                next_state <= DATA_BITS;
                data_bit_counter <= 1;
                data_byte[0] <= in;
            end

            DATA_BITS: begin
                data_byte[data_bit_counter] <= in;
                data_bit_counter <= data_bit_counter + 1;
                if (data_bit_counter == 8) begin
                    next_state <= STOP_BIT;
                end else begin
                    next_state <= DATA_BITS;
                end
            end

            STOP_BIT: begin
                if (in == 1) begin // Stop bit detected
                    next_state <= IDLE;
                    done_reg <= 1;
                    out_byte_reg <= data_byte;
                end else begin
                    next_state <= STOP_BIT_ERROR;
                end
            end

            STOP_BIT_ERROR: begin
                if (in == 1) begin // Stop bit detected
                    next_state <= IDLE;
                end else begin
                    next_state <= STOP_BIT_ERROR;
                end
            end

            default: next_state <= IDLE;
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule