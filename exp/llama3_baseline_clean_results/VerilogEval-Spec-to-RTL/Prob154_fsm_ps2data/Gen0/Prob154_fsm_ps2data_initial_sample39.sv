module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state; // IDLE, BYTE1, BYTE2
reg [7:0] byte1, byte2, byte3;

always @(*) begin
    case(state)
        2'b00: begin // IDLE
            if (in[3] == 1'b1) begin
                byte1 = in;
                state = 2'b01;
            end else begin
                state = 2'b00;
            end
        end
        2'b01: begin // BYTE1
            byte2 = in;
            state = 2'b10;
        end
        2'b10: begin // BYTE2
            byte3 = in;
            state = 2'b00; // Return to IDLE after DONE
            done = 1'b1;
        end
        default: state = 2'b00;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        done <= 1'b0;
        out_bytes <= 24'd0;
    end else begin
        case(state)
            2'b10: begin
                out_bytes <= {byte1, byte2, byte3};
            end
            default: done <= 1'b0;
        endcase
    end
end

endmodule