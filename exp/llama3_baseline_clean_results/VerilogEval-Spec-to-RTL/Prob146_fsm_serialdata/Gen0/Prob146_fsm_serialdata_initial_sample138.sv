module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

    reg [7:0] out_byte_reg;
    reg [2:0] state;
    reg [2:0] next_state;
    reg [3:0] bit_counter;
    reg [3:0] next_bit_counter;
    reg done_reg;

    // Define states
    parameter IDLE = 3'b000;
    parameter START = 3'b001;
    parameter DATA = 3'b010;
    parameter STOP = 3'b011;
    parameter ERROR = 3'b100;

    // Initialize state and bit counter
    initial begin
        state = IDLE;
        bit_counter = 0;
        out_byte_reg = 8'b0;
        done_reg = 1'b0;
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 0;
            out_byte_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            bit_counter <= next_bit_counter;
            done_reg <= 1'b0;
            if (done) begin
                out_byte_reg <= out_byte_reg;
            end else if (state == DATA) begin
                out_byte_reg[bit_counter - 1] <= in;
            end
        end
    end

    // Combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state = START;
                    next_bit_counter = 1;
                end else begin
                    next_state = IDLE;
                    next_bit_counter = 0;
                end
            end
            START: begin
                next_state = DATA;
                next_bit_counter = 1;
            end
            DATA: begin
                if (bit_counter == 8) begin
                    next_state = STOP;
                    next_bit_counter = 0;
                end else begin
                    next_state = DATA;
                    next_bit_counter = bit_counter + 1;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                    next_bit_counter = 0;
                    done_reg = 1'b1;
                end else begin
                    next_state = ERROR;
                    next_bit_counter = 0;
                end
            end
            ERROR: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                    next_bit_counter = 0;
                end else begin
                    next_state = ERROR;
                    next_bit_counter = 0;
                end
            end
        endcase
    end

    assign out_byte = out_byte_reg;
    assign done = done_reg;

endmodule