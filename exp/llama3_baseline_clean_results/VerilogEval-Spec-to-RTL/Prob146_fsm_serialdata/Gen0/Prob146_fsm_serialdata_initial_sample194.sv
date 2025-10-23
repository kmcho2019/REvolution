module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [2:0] state_next;
reg [2:0] bit_count_reg;
reg [7:0] data_reg;

localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam DATA = 3'b010;
localparam STOP = 3'b011;

always @(*) begin
    case (state_reg)
        IDLE: begin
            if (~in) begin // start bit detected
                state_next = START;
            end else begin
                state_next = IDLE;
            end
        end
        START: begin
            state_next = DATA;
            bit_count_reg = 0;
        end
        DATA: begin
            if (bit_count_reg == 7) begin
                state_next = STOP;
            end else begin
                state_next = DATA;
            end
        end
        STOP: begin
            if (in) begin // stop bit detected
                state_next = IDLE;
                done_reg = 1;
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
        done_reg <= 0;
        out_byte_reg <= 0;
        bit_count_reg <= 0;
        data_reg <= 0;
    end else begin
        state_reg <= state_next;
        done_reg <= (state_next == IDLE && state_reg == STOP) ? 1 : 0;
        if (state_reg == DATA) begin
            data_reg <= {data_reg[6:0], in};
            bit_count_reg <= bit_count_reg + 1;
        end
        if (state_reg == STOP) begin
            out_byte_reg <= data_reg;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule