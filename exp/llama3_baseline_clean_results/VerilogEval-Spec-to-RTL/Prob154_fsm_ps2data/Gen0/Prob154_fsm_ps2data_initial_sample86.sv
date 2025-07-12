module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
reg [7:0] byte1, byte2, byte3;

always @(*) begin
    case (state)
        2'b00: begin // IDLE
            if (in[3]) begin
                state = 2'b01; // BYTE1
                byte1 = in;
            end else begin
                state = 2'b00; // IDLE
            end
        end
        2'b01: begin // BYTE1
            state = 2'b10; // BYTE2
            byte2 = in;
        end
        2'b10: begin // BYTE2
            state = 2'b11; // BYTE3
            byte3 = in;
        end
        2'b11: begin // BYTE3
            state = 2'b00; // IDLE
            done = 1'b1;
            out_bytes = {byte1, byte2, byte3};
        end
        default: begin
            state = 2'b00; // IDLE
        end
    endcase
    
    if (reset) begin
        state = 2'b00;
        done = 1'b0;
    end
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        done <= 1'b0;
        out_bytes <= 24'b0;
    end else begin
        case (state)
            2'b11: begin
                done <= 1'b1;
                out_bytes <= {byte1, byte2, byte3};
            end
            default: begin
                done <= 1'b0;
            end
        endcase
    end
end

endmodule