module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

logic [1:0] byte_count;
logic        done_reg;

always_ff @(posedge clk) begin
    if(reset) begin
        byte_count <= 2'b00;
        done_reg  <= 1'b0;
    end
    else begin
        case(byte_count)
            2'b00: begin // IDLE state
                if(in[3]) byte_count <= 2'b01; // Transition to BYTE1 if in[3] = 1
            end
            2'b01: begin // BYTE1 state
                byte_count <= 2'b10; // Transition to BYTE2
            end
            2'b10: begin // BYTE2 state
                byte_count <= 2'b11; // Transition to BYTE3
            end
            2'b11: begin // BYTE3 state
                byte_count <= 2'b00; // Reset to IDLE
                done_reg  <= 1'b1; // Set done_reg to be asserted in the next cycle
            end
        endcase
    end
end

always_comb begin
    if(reset) begin
        done = 1'b0; // Reset done signal upon reset
    end
    else if(done_reg) begin
        done = 1'b1; // Assert done signal if done_reg is set
    end
    else begin
        done = 1'b0; // Deassert done signal otherwise
    end
end

// Optional: Simplify the always_comb block
// assign done = (done_reg && !reset);

endmodule