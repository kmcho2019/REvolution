module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    case(state)
        2'b00: begin // IDLE
            if (in[3]) next_state = 2'b01; // move to BYTE1 if in[3]=1
            else next_state = 2'b00; // stay in IDLE if in[3]=0
        end
        2'b01: begin // BYTE1
            next_state = 2'b10; // move to BYTE2
        end
        2'b10: begin // BYTE2
            next_state = 2'b11; // move to DONE
        end
        2'b11: begin // DONE
            next_state = 2'b00; // move back to IDLE
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        done <= 1'b0;
        out_bytes <= 24'd0;
    end else begin
        state <= next_state;
        case(state)
            2'b00: begin // IDLE
                out_bytes[7:0] <= 8'd0; // clear the first byte
                out_bytes[15:8] <= 8'd0; // clear the second byte
                out_bytes[23:16] <= 8'd0; // clear the third byte
                done <= 1'b0;
            end
            2'b01: begin // BYTE1
                out_bytes[7:0] <= 8'd0; // clear the first byte
                out_bytes[15:8] <= in; // store the second byte
                out_bytes[23:16] <= 8'd0; // clear the third byte
                done <= 1'b0;
            end
            2'b10: begin // BYTE2
                out_bytes[7:0] <= in; // store the first byte
                out_bytes[15:8] <= out_bytes[7:0]; // shift the second byte
                out_bytes[23:16] <= out_bytes[15:8]; // shift the third byte
                done <= 1'b0;
            end
            2'b11: begin // DONE
                out_bytes[7:0] <= out_bytes[15:8]; // shift the first byte
                out_bytes[15:8] <= out_bytes[23:16]; // shift the second byte
                out_bytes[23:16] <= in; // store the third byte
                done <= 1'b1;
            end
        endcase
    end
end

endmodule