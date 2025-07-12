module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
reg [1:0] byte_count;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Initialize to idle state
        byte_count <= 2'b00;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (in[3] == 1'b1) begin
                    out_bytes[23:16] <= in;
                    state <= 2'b01; // Transition to receiving state
                    byte_count <= 2'b01;
                end
                done <= 1'b0;
            end
            2'b01: begin // Receiving state
                case (byte_count)
                    2'b01: begin
                        out_bytes[15:8] <= in;
                        byte_count <= 2'b10;
                    end
                    2'b10: begin
                        out_bytes[7:0] <= in;
                        byte_count <= 2'b11;
                    end
                    2'b11: begin
                        state <= 2'b00; // Transition back to idle state
                        done <= 1'b1; // Signal done
                    end
                endcase
            end
        endcase
    end
end

endmodule