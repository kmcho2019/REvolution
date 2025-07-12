module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [2:0] state; // IDLE (0), START (1), DATA (2), STOP (3), ERROR (4)
reg [7:0] data; // store the received data bits
reg [2:0] count; // count the number of data bits received
reg [7:0] out_byte_reg; // output register for out_byte
reg done_reg; // output register for done

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        data <= 8'b0;
        count <= 0;
        out_byte_reg <= 8'b0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // START
                end else begin
                    state <= 0; // stay in IDLE
                end
            end
            1: begin // START
                state <= 2; // DATA
                data <= 8'b0; // clear data register
                count <= 0; // clear data bit counter
            end
            2: begin // DATA
                data <= {data[6:0], in}; // shift in the new data bit
                count <= count + 1;
                if (count == 8) begin
                    state <= 3; // STOP
                end
            end
            3: begin // STOP
                if (in) begin // stop bit detected
                    out_byte_reg <= data; // output the received data
                    done_reg <= 1; // assert done
                    state <= 0; // IDLE
                end else begin // stop bit not detected
                    state <= 4; // ERROR
                end
            end
            4: begin // ERROR
                if (in) begin // stop bit detected
                    state <= 0; // IDLE
                end
            end
            default: begin
                state <= 0; // IDLE
            end
        endcase
        done_reg <= (state == 3 && in) ? 1'b1 : 1'b0;
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule