module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [7:0] data;
reg [3:0] count;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        count <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin
                    state <= 1;
                end
            end
            1: begin // START
                state <= 2;
                count <= 0;
            end
            2: begin // DATA
                data[count] <= in;
                count <= count + 1;
                if (count == 8) begin
                    state <= 3;
                end
            end
            3: begin // STOP
                if (in) begin
                    state <= 0;
                    done_reg <= 1;
                end else begin
                    state <= 3;
                end
            end
            default: state <= 0;
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 0;
    end else if (done_reg) begin
        done <= 1;
        done_reg <= 0;
    end else begin
        done <= 0;
    end
end

endmodule