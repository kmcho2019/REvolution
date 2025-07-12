module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state;
reg [1:0] next_state;
reg done_reg;
reg [1:0] count;

always @(*) begin
    case(state)
        2'b00: begin // IDLE
            if(in[3] == 1'b1) begin
                next_state = 2'b01; // Transition to BYTE1
            end else begin
                next_state = 2'b00; // Stay in IDLE
            end
        end
        2'b01: begin // BYTE1
            next_state = 2'b10; // Transition to BYTE2
        end
        2'b10: begin // BYTE2
            next_state = 2'b11; // Transition to BYTE3
        end
        2'b11: begin // BYTE3
            next_state = 2'b00; // Transition back to IDLE
        end
        default: next_state = 2'b00; // Stay in IDLE
    endcase

    if(next_state == 2'b11) begin
        done_reg = 1'b1; // Assert done for one cycle
    end else begin
        done_reg = 1'b0; // Deassert done
    end
end

always @(posedge clk) begin
    if(reset == 1'b1) begin
        state <= 2'b00; // Reset state machine to IDLE
        done_reg <= 1'b0; // Deassert done
    end else begin
        state <= next_state; // Update state
        done <= done_reg; // Update done signal
    end
end

endmodule