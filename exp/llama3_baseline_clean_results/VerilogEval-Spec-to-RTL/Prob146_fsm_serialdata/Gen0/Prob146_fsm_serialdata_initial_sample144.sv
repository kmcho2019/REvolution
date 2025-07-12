module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state;
reg [2:0] bit_count;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b001; // Idle state
        bit_count <= 3'b000;
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            3'b001: begin // Idle state
                if (!in) begin // Start bit detected
                    state <= 3'b010; // Transition to Start state
                    out_byte_reg <= 8'b0;
                end
            end
            3'b010: begin // Start state
                state <= 3'b011; // Transition to Data state
                bit_count <= 3'b000;
            end
            3'b011: begin // Data state
                out_byte_reg[bit_count] <= in; // Store the incoming bit
                bit_count <= bit_count + 1'b1;
                if (bit_count == 3'b111) begin // All 8 data bits received
                    state <= 3'b100; // Transition to Stop state
                end
            end
            3'b100: begin // Stop state
                if (in) begin // Stop bit detected
                    done_reg <= 1'b1; // Assert done signal
                    state <= 3'b001; // Transition to Idle state
                end else begin
                    state <= 3'b100; // Wait for stop bit
                end
            end
            default: begin
                state <= 3'b001; // Transition to Idle state
            end
        endcase
        if (state == 3'b100) begin // Stop state
            done_reg <= 1'b0; // Deassert done signal
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule