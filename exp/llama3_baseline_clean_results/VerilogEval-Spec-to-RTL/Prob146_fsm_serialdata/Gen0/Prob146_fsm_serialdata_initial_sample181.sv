module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] byte;
reg [2:0] count;
reg [1:0] state;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        count <= 3'b000;
        done_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (~in) begin // start bit detected
                    state <= 2'b01; // START
                    byte <= 8'b0;
                    count <= 3'b000;
                end
            end
            2'b01: begin // START
                state <= 2'b10; // DATA
            end
            2'b10: begin // DATA
                byte <= {byte[6:0], in}; // shift in data bit
                count <= count + 1;
                if (count == 8) begin
                    state <= 2'b11; // STOP
                end
            end
            2'b11: begin // STOP
                if (in) begin // stop bit detected
                    done_reg <= 1'b1;
                    state <= 2'b00; // IDLE
                end
            end
        endcase
    end
end

assign out_byte = byte;
assign done = done_reg;

always @(posedge clk) begin
    if (state == 2'b11 && ~in) begin // invalid stop bit, wait for stop bit
        state <= 2'b00; // IDLE
        count <= 3'b000;
        done_reg <= 1'b0;
    end
end

endmodule