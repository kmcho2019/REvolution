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
        done_reg   <= 1'b0;
    end
    else begin
        case(byte_count)
            2'b00: begin // IDLE state
                if(in[3]) byte_count <= 2'b01; // Transition to BYTE1 if in[3] = 1
            end
            2'b01, 2'b10: begin // BYTE1 and BYTE2 states
                byte_count <= byte_count + 1'b1; // Increment byte counter
            end
            2'b11: begin // BYTE3 state
                byte_count <= 2'b00; // Reset to IDLE
                done_reg   <= 1'b1; // Set done signal
            end
        endcase
    end
end

always_comb begin
    if(done_reg) begin
        done = 1'b1;
    end
    else begin
        done = 1'b0;
    end
end

always_ff @(posedge clk) begin
    if(reset) begin
        done_reg <= 1'b0;
    end
    else if(byte_count == 2'b11) begin
        done_reg <= 1'b1;
    end
    else begin
        done_reg <= 1'b0;
    end
end

endmodule