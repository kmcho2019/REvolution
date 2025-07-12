module TopModule(
    input           clk,
    input           reset,
    input           in,
    output          done
);

reg [2:0] state; // 0: IDLE, 1: DATA, 2: STOP
reg [2:0] data_count;
reg [7:0] data;
reg       start_bit;
reg       stop_bit;
reg       done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        data_count <= 0;
        data <= 0;
        start_bit <= 0;
        stop_bit <= 0;
        done_reg <= 0;
    end
    else begin
        case (state)
            0: begin // IDLE
                if (~in) begin
                    state <= 1;
                    data_count <= 0;
                    data <= 0;
                    start_bit <= 1;
                end
            end
            1: begin // DATA
                data_count <= data_count + 1;
                data[7 - data_count] <= in;
                if (data_count == 8) begin
                    state <= 2;
                end
            end
            2: begin // STOP
                if (in) begin
                    done_reg <= 1;
                    state <= 0;
                end
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

assign done = done_reg;

always @(posedge clk) begin
    done_reg <= 0;
end

endmodule