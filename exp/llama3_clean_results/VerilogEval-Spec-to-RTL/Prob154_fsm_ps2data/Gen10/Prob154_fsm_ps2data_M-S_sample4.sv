module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
reg [23:0] temp_out_bytes;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        temp_out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (in[3] == 1'b1) begin
                    temp_out_bytes[23:16] <= in;
                    state <= 2'b01; // Transition to byte1 state
                end
            end
            2'b01: begin // Byte1 state
                temp_out_bytes[15:8] <= in;
                state <= 2'b10; // Transition to byte2 state
            end
            2'b10: begin // Byte2 state
                temp_out_bytes[7:0] <= in;
                out_bytes <= temp_out_bytes; // Assign temp_out_bytes to out_bytes
                state <= 2'b00; // Transition back to idle state
                done <= 1'b1; // Signal done
            end
        endcase
    end
end

endmodule