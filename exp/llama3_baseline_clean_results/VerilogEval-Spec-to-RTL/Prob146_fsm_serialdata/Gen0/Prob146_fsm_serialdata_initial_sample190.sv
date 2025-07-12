module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state; // IDLE, START, DATA, STOP, DONE
reg [3:0] counter; // Counter for data bits
reg [7:0] data_reg; // Register to hold the received data

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        counter <= 0;
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // Found start bit
                    state <= 1; // START
                end
            end
            1: begin // START
                state <= 2; // DATA
                data_reg <= 8'b0;
            end
            2: begin // DATA
                data_reg <= {data_reg[6:0], in}; // Shift in the data bit
                counter <= counter + 1;
                if (counter == 8) begin
                    state <= 3; // STOP
                end
            end
            3: begin // STOP
                if (in) begin // Found stop bit
                    state <= 4; // DONE
                    out_byte_reg <= data_reg;
                end else begin // No stop bit, go back to IDLE
                    state <= 0; // IDLE
                end
            end
            4: begin // DONE
                done_reg <= 1'b1;
                state <= 0; // IDLE
            end
            default: state <= 0; // IDLE
        endcase
    end
end

always @(posedge clk) begin
    if (state != 4) begin // Not in DONE state
        done_reg <= 1'b0;
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule