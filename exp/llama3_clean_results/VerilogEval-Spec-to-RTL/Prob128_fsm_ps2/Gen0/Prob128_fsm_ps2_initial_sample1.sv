module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state; // 2 bits to represent 4 states
reg [1:0] nextState;

always @(*) begin
    case(state)
        2'b00: // IDLE
            if(in[3] == 1'b1) begin
                nextState = 2'b01; // BYTE1
            end else begin
                nextState = 2'b00; // Stay in IDLE
            end
        2'b01: // BYTE1
            nextState = 2'b10; // BYTE2
        2'b10: // BYTE2
            nextState = 2'b11; // DONE
        2'b11: // DONE
            nextState = 2'b00; // IDLE
        default:
            nextState = 2'b00; // IDLE
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // Reset to IDLE
        done <= 1'b0;
    end else begin
        state <= nextState;
        if(state == 2'b11) begin // DONE
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end
end

endmodule