module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] data_byte;
reg [2:0] state; // 3 states: IDLE (0), START (1), DATA (2), STOP (3, 4, 5, 6, 7)
reg [2:0] bit_counter;
reg [7:0] shift_reg;

// State definitions
localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam DATA = 3'b010;
localparam STOP = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        bit_counter <= 0;
        shift_reg <= 8'b0;
        out_byte <= 8'b0;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in == 0) begin // Start bit detected
                    state <= START;
                end else begin
                    state <= IDLE;
                end
            end
            START: begin
                shift_reg[0] <= in;
                state <= DATA;
                bit_counter <= 1;
            end
            DATA: begin
                shift_reg[bit_counter] <= in;
                bit_counter <= bit_counter + 1;
                if (bit_counter == 8) begin
                    state <= STOP;
                end
            end
            STOP: begin
                if (in == 1) begin // Stop bit detected
                    data_byte <= {shift_reg[7:1], shift_reg[0]};
                    out_byte <= data_byte;
                    done <= 1;
                    state <= IDLE;
                end else begin
                    state <= STOP;
                end
            end
            default: state <= IDLE;
        endcase
        if (state != STOP) begin
            done <= 0;
        end
    end
end

endmodule