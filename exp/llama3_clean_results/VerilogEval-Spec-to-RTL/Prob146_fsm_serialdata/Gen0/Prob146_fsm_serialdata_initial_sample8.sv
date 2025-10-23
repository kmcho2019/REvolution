module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 3 states: IDLE (0), START (1), DATA (2), STOP (3), ERROR (4)
reg [2:0] state_next;
reg [3:0] data_count_reg;
reg [3:0] data_count_next;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= 0; // IDLE
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
        data_count_reg <= 4'b0;
    end else begin
        state_reg <= state_next;
        out_byte_reg <= (state_next == 3) ? {out_byte_reg[6:0], in} : out_byte_reg;
        done_reg <= (state_next == 3) ? 1'b1 : 1'b0;
        data_count_reg <= data_count_next;
    end
end

always @(*) begin
    case (state_reg)
        0: begin // IDLE
            if (in == 1'b0) begin // start bit
                state_next = 1; // START
                data_count_next = 4'b1;
            end else begin
                state_next = 0; // IDLE
                data_count_next = 4'b0;
            end
        end
        1: begin // START
            state_next = 2; // DATA
            data_count_next = 4'b1;
        end
        2: begin // DATA
            if (data_count_reg == 4'b1000) begin // received 8 data bits
                state_next = 3; // STOP
            end else begin
                state_next = 2; // DATA
            end
            data_count_next = (data_count_reg == 4'b1000) ? 4'b0 : data_count_reg + 1'b1;
        end
        3: begin // STOP
            if (in == 1'b1) begin // stop bit
                state_next = 0; // IDLE
            end else begin
                state_next = 4; // ERROR
            end
            data_count_next = 4'b0;
        end
        4: begin // ERROR
            if (in == 1'b1) begin // stop bit
                state_next = 0; // IDLE
            end else begin
                state_next = 4; // ERROR
            end
            data_count_next = 4'b0;
        end
        default: begin
            state_next = 0; // IDLE
            data_count_next = 4'b0;
        end
    endcase
end

assign out_byte = (state_reg == 3) ? out_byte_reg : 8'bxxxxxxxx;
assign done = done_reg;

endmodule