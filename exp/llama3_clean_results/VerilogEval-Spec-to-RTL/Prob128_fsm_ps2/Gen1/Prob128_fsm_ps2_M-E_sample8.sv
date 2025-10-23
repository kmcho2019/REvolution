module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state; // 0: IDLE, 1: RECV, 2: DONE
reg [1:0] counter;
reg [7:0] bytes [2:0];
reg done_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0;
        counter <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    state <= 1;
                    counter <= 1;
                    bytes[0] <= in;
                end
            end
            1: begin // RECV
                bytes[counter] <= in;
                counter <= counter + 1;
                if (counter == 3) begin
                    state <= 2;
                end
            end
            2: begin // DONE
                done_reg <= 1;
                state <= 0;
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

always @ (posedge clk) begin
    if (state != 2) begin
        done_reg <= 0;
    end
end

assign done = done_reg;

endmodule