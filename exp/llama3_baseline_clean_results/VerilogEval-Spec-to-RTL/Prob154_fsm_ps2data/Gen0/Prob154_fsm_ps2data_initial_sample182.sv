module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output [23:0] out_bytes,
    output        done
);

    reg [1:0] state;
    reg [1:0] next_state;
    reg [23:0] out_bytes_reg;
    reg        done_reg;

    always @(*) begin
        case (state)
            2'b00: begin // IDLE state
                if (in[3] == 1'b1) begin
                    next_state = 2'b01;
                    out_bytes_reg = {in, 16'd0};
                end else begin
                    next_state = 2'b00;
                    out_bytes_reg = out_bytes_reg;
                end
                done_reg = 1'b0;
            end
            2'b01: begin // BYTE1 state
                next_state = 2'b10;
                out_bytes_reg = {out_bytes_reg[15:0], in};
                done_reg = 1'b0;
            end
            2'b10: begin // BYTE2 state
                next_state = 2'b11;
                out_bytes_reg = {out_bytes_reg[7:0], in, 8'd0};
                done_reg = 1'b0;
            end
            2'b11: begin // BYTE3 state
                next_state = 2'b00;
                out_bytes_reg = {in, out_bytes_reg[15:8], 8'd0};
                done_reg = 1'b1;
            end
            default: begin
                next_state = 2'b00;
                out_bytes_reg = out_bytes_reg;
                done_reg = 1'b0;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            out_bytes_reg <= 24'd0;
            done_reg <= 1'b0;
        end else begin
            state <= next_state;
            out_bytes_reg <= out_bytes_reg;
            done_reg <= done_reg;
        end
    end

    assign out_bytes = out_bytes_reg;
    assign done = done_reg;

endmodule