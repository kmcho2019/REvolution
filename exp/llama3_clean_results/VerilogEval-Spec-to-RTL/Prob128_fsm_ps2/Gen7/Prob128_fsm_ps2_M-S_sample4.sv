module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

logic [1:0] state;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // Reset to IDLE state
        done <= 1'b0; // Deassert done
    end
    else begin
        case(state)
            2'b00: begin // IDLE state
                if(in[3]) state <= 2'b01; // Transition to BYTE1 if in[3] = 1
                done <= 1'b0; // Deassert done in IDLE
            end
            2'b01: state <= 2'b10; // Transition to BYTE2
            2'b10: state <= 2'b11; // Transition to BYTE3
            2'b11: begin // BYTE3 state
                state <= 2'b00; // Reset to IDLE
                done <= 1'b1; // Assert done
            end
            default: state <= 2'b00; // Default to IDLE if unexpected state
        endcase
    end
end

endmodule