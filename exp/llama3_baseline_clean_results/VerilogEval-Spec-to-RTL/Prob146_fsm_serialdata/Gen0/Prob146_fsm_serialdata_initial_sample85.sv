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
reg [2:0] next_state;
reg [3:0] count;
reg [7:0] data;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        count <= 0;
        data <= 0;
        done_reg <= 0;
        out_byte_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1;
                    count <= 0;
                end else begin
                    state <= 0;
                end
            end
            1: begin // START
                state <= 2;
            end
            2: begin // DATA
                data[count] <= in;
                count <= count + 1;
                if (count == 8) begin
                    state <= 3;
                end else begin
                    state <= 2;
                end
            end
            3: begin // STOP
                if (in) begin // stop bit detected
                    state <= 4;
                end else begin
                    state <= 0; // incorrect stop bit, restart
                end
            end
            4: begin // DONE
                state <= 0;
            end
            default: state <= 0;
        endcase
        if (state == 4) begin
            out_byte_reg <= data;
            done_reg <= 1;
        end else begin
            done_reg <= 0;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule