module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

// Define states
enum logic [2:0] {IDLE, RECEIVE_DATA, VERIFY_STOP} state, next_state;

// Counter for data bits
logic [3:0] data_count;

// Register for received data
logic [7:0] data_reg;

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data_count <= 4'd0;
        data_reg <= 8'd0;
        done <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (~in) begin
                    state <= RECEIVE_DATA;
                    data_count <= 4'd1;
                    data_reg[0] <= in;
                end
                else begin
                    state <= IDLE;
                end
            end
            RECEIVE_DATA: begin
                data_reg <= {data_reg[6:0], in};
                data_count <= data_count + 1;
                if (data_count == 4'd8) begin
                    state <= VERIFY_STOP;
                end
                else begin
                    state <= RECEIVE_DATA;
                end
            end
            VERIFY_STOP: begin
                if (in) begin
                    state <= IDLE;
                    done <= 1'b1;
                end
                else begin
                    state <= VERIFY_STOP;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

always_ff @(posedge clk) begin
    if (state != VERIFY_STOP || in) begin
        done <= 1'b0;
    end
end

endmodule