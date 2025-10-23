module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

enum {IDLE, WAITING} state, next_state;
reg [7:0] data_lock;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state     <= IDLE;
        data_lock <= 8'd0;
        data_out  <= 16'd0;
        valid_out <= 1'b0;
    end
    else begin
        state     <= next_state;
        if (next_state == WAITING) begin
            data_lock <= data_in;
        end
        if (next_state == IDLE && valid_in) begin
            data_out  <= {data_lock, data_in};
            valid_out <= 1'b1;
        end
        else begin
            valid_out <= 1'b0;
        end
    end
end

always @* begin
    case (state)
        IDLE: begin
            if (valid_in) begin
                next_state = WAITING;
            end
            else begin
                next_state = IDLE;
            end
        end
        WAITING: begin
            if (valid_in) begin
                next_state = IDLE;
            end
            else begin
                next_state = WAITING;
            end
        end
    endcase
end

endmodule