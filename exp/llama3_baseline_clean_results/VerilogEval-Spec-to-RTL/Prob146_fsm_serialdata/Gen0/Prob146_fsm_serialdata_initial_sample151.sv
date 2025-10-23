module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

enum logic [2:0] {
    IDLE,
    START,
    COLLECT,
    VERIFY
} state, next_state;

logic [7:0] byte;
logic [2:0] count;
logic done_reg;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 1'b0;
        byte <= 8'b0;
        count <= 3'b0;
    end else begin
        state <= next_state;
        done_reg <= 1'b0;
        case (state)
            START: begin
                byte <= 8'b0;
                count <= 3'b0;
            end
            COLLECT: begin
                byte <= {byte[6:0], in};
                count <= count + 1'b1;
            end
            VERIFY: begin
                if (in) begin // Stop bit verified
                    done_reg <= 1'b1;
                end
            end
        endcase
    end
end

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (~in) begin // Start bit detected
                next_state = START;
            end
        end
        START: begin
            next_state = COLLECT;
        end
        COLLECT: begin
            if (count == 3'b111) begin // 8 bits collected
                next_state = VERIFY;
            end
        end
        VERIFY: begin
            if (in) begin // Stop bit verified
                next_state = IDLE;
            end else begin // Incorrect stop bit, wait for stop bit
                next_state = IDLE;
            end
        end
    endcase
end

assign out_byte = byte;
assign done = done_reg;

endmodule