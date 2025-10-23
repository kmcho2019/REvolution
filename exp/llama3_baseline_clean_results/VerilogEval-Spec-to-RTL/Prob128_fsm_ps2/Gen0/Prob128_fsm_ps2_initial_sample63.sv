module TopModule (
    input           clk,
    input           reset,
    input   [7:0]    in,
    output          done
);

reg [1:0] state;
reg       done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (in[3] == 1'b1) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin // Byte 1 received
                state <= 2'b10;
            end
            2'b10: begin // Byte 2 received
                if (in[3] == 1'b1) begin
                    state <= 2'b01; // Restart if byte with in[3] = 1 is received
                end else begin
                    state <= 2'b11;
                end
            end
            2'b11: begin // Byte 3 received
                if (in[3] == 1'b1) begin
                    state <= 2'b01; // Restart if byte with in[3] = 1 is received
                end else begin
                    done_reg <= 1'b1;
                    state <= 2'b00;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    done <= done_reg;
    if (reset || state != 2'b11) begin
        done_reg <= 1'b0;
    end
end

endmodule