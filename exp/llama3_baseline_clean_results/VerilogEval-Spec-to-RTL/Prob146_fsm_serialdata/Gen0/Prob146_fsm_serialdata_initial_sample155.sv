module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 0: idle, 1: start, 2: data, 3: stop
reg [2:0] data_count; // counter for data bits
reg [7:0] data_reg; // register to store received data bits

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 0; // idle
        out_byte_reg <= 8'b0;
        done_reg <= 0;
        data_count <= 0;
        data_reg <= 8'b0;
    end else begin
        case (state_reg)
            0: begin // idle
                if (!in) begin
                    state_reg <= 1; // start
                    data_reg <= 8'b0;
                    data_count <= 0;
                end else begin
                    state_reg <= 0; // idle
                end
            end
            1: begin // start
                state_reg <= 2; // data
                data_reg[0] <= in;
                data_count <= 1;
            end
            2: begin // data
                if (data_count == 7) begin
                    data_reg[7] <= in;
                    state_reg <= 3; // stop
                end else begin
                    data_reg[data_count + 1] <= in;
                    data_count <= data_count + 1;
                end
            end
            3: begin // stop
                if (in) begin // correct stop bit
                    state_reg <= 0; // idle
                    out_byte_reg <= data_reg;
                    done_reg <= 1;
                end else begin // incorrect stop bit
                    state_reg <= 0; // idle
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (!done_reg && state_reg == 3) begin
        done_reg <= 0;
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule