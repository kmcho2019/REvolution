module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state;
reg [2:0] count;
reg [7:0] data_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;  // IDLE
        count <= 0;
        done_reg <= 0;
        out_byte_reg <= 0;
        data_reg <= 0;
    end else begin
        case (state)
            0: begin  // IDLE
                if (!in) begin
                    state <= 1;  // START
                end
            end
            1: begin  // START
                state <= 2;  // DATA
                count <= 1;
                data_reg <= {7'b0, in};
            end
            2: begin  // DATA
                if (count < 8) begin
                    count <= count + 1;
                    data_reg <= {data_reg[6:0], in};
                end else if (in == 1) begin
                    state <= 3;  // STOP
                    out_byte_reg <= data_reg;
                    done_reg <= 1;
                end else begin
                    state <= 0;  // IDLE
                end
            end
            3: begin  // STOP
                if (in == 1) begin
                    state <= 0;  // IDLE
                    done_reg <= 0;
                end
            end
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule