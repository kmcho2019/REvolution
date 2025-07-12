module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

    reg [7:0] out_byte_reg;
    reg [2:0] state_reg;
    reg [2:0] state_next;
    reg [3:0] bit_counter;

    parameter IDLE = 3'b000;
    parameter START = 3'b001;
    parameter DATA = 3'b010;
    parameter STOP = 3'b011;

    always @(*) begin
        case (state_reg)
            IDLE: begin
                if (in == 0) begin
                    state_next = START;
                    bit_counter = 0;
                end else begin
                    state_next = IDLE;
                end
            end
            START: begin
                if (bit_counter == 8) begin
                    state_next = STOP;
                end else begin
                    state_next = DATA;
                end
            end
            DATA: begin
                if (bit_counter == 8) begin
                    state_next = STOP;
                end else begin
                    state_next = DATA;
                end
            end
            STOP: begin
                if (in == 1) begin
                    state_next = IDLE;
                end else begin
                    state_next = STOP;
                end
            end
            default: begin
                state_next = IDLE;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state_reg <= IDLE;
            bit_counter <= 0;
            out_byte_reg <= 0;
        end else begin
            state_reg <= state_next;
            if (state_reg == DATA) begin
                out_byte_reg[bit_counter] <= in;
                bit_counter <= bit_counter + 1;
            end
            if (state_reg == STOP && in == 1) begin
                out_byte <= out_byte_reg;
                bit_counter <= 0;
            end
            if (state_reg == STOP && in == 1) begin
                done <= 1;
            end else begin
                done <= 0;
            end
        end
    end

endmodule