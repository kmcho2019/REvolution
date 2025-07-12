module TopModule (
    input        clk,
    input        reset,
    input        in,
    output       done
);

enum logic [2:0] {
    IDLE,
    START_BIT,
    DATA_BITS,
    STOP_BIT
} state, next_state;

reg [7:0] data; // Collected data bits
reg [2:0] data_counter; // Counter for data bits
reg done_reg; // Registered output

always_comb begin
    next_state = state;
    case (state)
        IDLE: if (!in) next_state = START_BIT;
        START_BIT: begin
            next_state = DATA_BITS;
        end
        DATA_BITS: begin
            if (data_counter == 8) next_state = STOP_BIT;
            else next_state = DATA_BITS;
        end
        STOP_BIT: if (in) next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        data_counter <= 3'b0;
        done_reg <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            START_BIT: begin
                data <= {data[6:0], in}; // Collect least significant bit first
                data_counter <= 3'b1;
            end
            DATA_BITS: begin
                data <= {data[6:0], in}; // Collect least significant bit first
                data_counter <= data_counter + 1;
            end
            STOP_BIT: begin
                if (in) begin
                    done_reg <= 1'b1;
                end else begin
                    done_reg <= 1'b0;
                end
            end
            default: begin
                data_counter <= 3'b0;
                done_reg <= 1'b0;
            end
        endcase
    end
end

assign done = done_reg;

endmodule