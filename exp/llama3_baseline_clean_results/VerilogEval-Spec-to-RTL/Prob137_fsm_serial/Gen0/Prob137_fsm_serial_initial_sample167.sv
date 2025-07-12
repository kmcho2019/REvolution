module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [2:0] state; // IDLE, DATA, STOP
reg [2:0] count; // counter for data bits
reg [7:0] data; // received data
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        count <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // DATA
                    count <= 1;
                    data[0] <= 1'b0;
                end
            end
            1: begin // DATA
                if (count < 8) begin
                    data[count] <= in;
                    count <= count + 1;
                end else begin
                    state <= 2; // STOP
                end
            end
            2: begin // STOP
                if (in) begin // stop bit detected
                    state <= 0; // IDLE
                    done_reg <= 1;
                end else begin // no stop bit, go back to IDLE
                    state <= 0; // IDLE
                end
            end
            default: begin
                state <= 0; // IDLE
            end
        endcase
    end
end

assign done = done_reg;

endmodule