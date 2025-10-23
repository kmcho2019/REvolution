module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state;
reg [1:0] byte_num;
reg [23:0] message;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        byte_num <= 2'b00;
        message <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3]) begin
                    state <= 2'b01; // RECV
                    byte_num <= 2'b01;
                    message <= {in, 16'b0};
                end
            end
            2'b01: begin // RECV
                case (byte_num)
                    2'b01: begin
                        message <= {message[15:0], in};
                        byte_num <= 2'b10;
                    end
                    2'b10: begin
                        message <= {message[7:0], in, 8'b0};
                        byte_num <= 2'b11;
                    end
                    2'b11: begin
                        state <= 2'b00; // IDLE
                        byte_num <= 2'b00;
                        done <= 1'b1;
                    end
                endcase
            end
        endcase
        if (done) begin
            done <= 1'b0;
        end
    end
end

assign out_bytes = message;

endmodule