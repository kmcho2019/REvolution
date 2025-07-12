module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [2:0] state; // 0: Idle, 1: Receive, 2: VerifyStop
reg [2:0] bit_counter; // counter to keep track of the number of bits received
reg [7:0] out_byte_reg; // register to store the received byte
reg done_reg; // register to store the done signal

// assign output
assign out_byte = out_byte_reg;
assign done = done_reg;

always @ (posedge clk) begin
    if (reset) begin
        // reset to Idle state
        state <= 0;
        bit_counter <= 0;
        out_byte_reg <= 8'b0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // Idle state
                if (!in) begin
                    // start bit received, go to Receive state
                    state <= 1;
                    bit_counter <= 1;
                    out_byte_reg <= {7'b0, in};
                end else begin
                    // still in Idle state
                    state <= 0;
                end
            end
            1: begin // Receive state
                out_byte_reg <= {out_byte_reg[6:0], in}; // shift in the received bit
                bit_counter <= bit_counter + 1;
                if (bit_counter == 8) begin
                    // all 8 data bits received, go to VerifyStop state
                    state <= 2;
                end else begin
                    // still in Receive state
                    state <= 1;
                end
            end
            2: begin // VerifyStop state
                if (in) begin
                    // stop bit received, assert done signal and go back to Idle state
                    done_reg <= 1;
                    state <= 0;
                end else begin
                    // no stop bit received, stay in VerifyStop state
                    state <= 2;
                end
            end
        endcase
        // clear done signal on the next clock cycle
        if (done_reg) begin
            done_reg <= 0;
        end
    end
end

endmodule