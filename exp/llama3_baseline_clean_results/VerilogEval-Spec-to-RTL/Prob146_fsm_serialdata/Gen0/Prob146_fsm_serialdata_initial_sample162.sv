module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 0: IDLE, 1: START_BIT, 2: DATA_BITS, 3: STOP_BIT, 4: ERROR
reg [2:0] state_next;
reg [7:0] data_reg;
reg [3:0] counter_reg;
reg [3:0] counter_next;

always @(*) begin
    case(state_reg)
        0: begin // IDLE
            if (~in) begin
                state_next = 1; // START_BIT
            end else begin
                state_next = 0; // IDLE
            end
        end
        1: begin // START_BIT
            if (in) begin
                state_next = 4; // ERROR
            end else begin
                state_next = 2; // DATA_BITS
            end
        end
        2: begin // DATA_BITS
            if (counter_reg == 8) begin
                state_next = 3; // STOP_BIT
            end else begin
                state_next = 2; // DATA_BITS
            end
        end
        3: begin // STOP_BIT
            if (in) begin
                state_next = 0; // IDLE
            end else begin
                state_next = 4; // ERROR
            end
        end
        4: begin // ERROR
            if (in) begin
                state_next = 0; // IDLE
            end else begin
                state_next = 4; // ERROR
            end
        end
        default: state_next = 0; // IDLE
    endcase
end

always @(*) begin
    case(state_reg)
        2: begin // DATA_BITS
            if (counter_reg < 8) begin
                counter_next = counter_reg + 1;
            end else begin
                counter_next = counter_reg;
            end
        end
        default: counter_next = 0;
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= 0; // IDLE
        counter_reg <= 0;
        data_reg <= 8'b0;
        out_byte_reg <= 8'b0;
        done_reg <= 0;
    end else begin
        state_reg <= state_next;
        counter_reg <= counter_next;
        if (state_reg == 2) begin // DATA_BITS
            data_reg <= {data_reg[6:0], in}; // Shift in the new bit
        end else begin
            data_reg <= 8'b0;
        end
        if (state_reg == 3 && in) begin // STOP_BIT
            out_byte_reg <= data_reg;
            done_reg <= 1;
        end else begin
            done_reg <= 0;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule