module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [2:0] data_count;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        out_byte_reg <= 0;
        data_count <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // Start bit detected
                    state <= 1; // START
                    out_byte_reg <= 0;
                    data_count <= 0;
                end
            end
            1: begin // START
                state <= 2; // DATA
            end
            2: begin // DATA
                out_byte_reg <= {out_byte_reg[6:0], in};
                data_count <= data_count + 1;
                if (data_count == 7) begin
                    state <= 3; // STOP
                end
            end
            3: begin // STOP
                if (in) begin // Stop bit detected
                    done_reg <= 1;
                    state <= 0; // IDLE
                end
            end
            default: state <= 0; // IDLE
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

always @(posedge clk) begin
    if (state == 0 && !done_reg) begin
        done_reg <= 0;
    end
end

endmodule