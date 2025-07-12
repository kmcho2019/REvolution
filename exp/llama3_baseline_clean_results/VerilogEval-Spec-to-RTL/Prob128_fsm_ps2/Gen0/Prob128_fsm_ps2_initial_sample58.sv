module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 2-bit state variable
reg [1:0] nextState;

always @(*) begin
    case(state)
        2'b00: begin // Idle
            if(in[3]) begin
                nextState = 2'b01; // Go to Byte1
            end else begin
                nextState = 2'b00; // Stay in Idle
            end
        end
        2'b01: begin // Byte1
            nextState = 2'b10; // Go to Byte2
        end
        2'b10: begin // Byte2
            nextState = 2'b11; // Go to Done
        end
        2'b11: begin // Done
            nextState = 2'b00; // Go back to Idle
        end
        default: begin
            nextState = 2'b00; // Go back to Idle
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00;
        done <= 0;
    end else begin
        state <= nextState;
        if(state == 2'b11) begin
            done <= 1; // Assert done in the cycle immediately after the third byte
        end else begin
            done <= 0;
        end
    end
end

endmodule