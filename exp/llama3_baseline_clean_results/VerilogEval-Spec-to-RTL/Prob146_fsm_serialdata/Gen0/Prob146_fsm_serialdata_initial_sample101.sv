module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 3 states: IDLE (3'b000), START (3'b001), DATA (3'b010), STOP (3'b011)
reg [3:0] bit_count_reg; // Counter for data bits
reg [7:0] data_reg; // Register to hold the received data bits

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 3'b000; // IDLE state
        done_reg <= 1'b0;
        out_byte_reg <= 8'b0;
        bit_count_reg <= 4'b0;
        data_reg <= 8'b0;
    end else begin
        case (state_reg)
            3'b000: begin // IDLE state
                if (in == 1'b0) begin // Start bit detected
                    state_reg <= 3'b001; // Move to START state
                end
            end
            3'b001: begin // START state
                state_reg <= 3'b010; // Move to DATA state
                data_reg[0] <= in; // Shift in the first data bit
                bit_count_reg <= 4'b1;
            end
            3'b010: begin // DATA state
                data_reg <= {data_reg[6:0], in}; // Shift in the next data bit
                bit_count_reg <= bit_count_reg + 1'b1;
                if (bit_count_reg == 4'b1000) begin // 8 data bits received
                    state_reg <= 3'b011; // Move to STOP state
                end
            end
            3'b011: begin // STOP state
                if (in == 1'b1) begin // Stop bit detected
                    out_byte_reg <= data_reg; // Output the received byte
                    done_reg <= 1'b1;
                    state_reg <= 3'b000; // Move back to IDLE state
                end else begin // Stop bit not detected, wait for it
                    state_reg <= 3'b011; // Stay in STOP state
                end
            end
            default: begin
                state_reg <= 3'b000; // Reset to IDLE state
            end
        endcase
    end
end

always @(posedge clk) begin
    if (done_reg) begin
        done_reg <= 1'b0; // Deassert done after one clock cycle
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule