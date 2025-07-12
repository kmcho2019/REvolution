module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // idle = 2'b00, byte1 = 2'b01, byte2 = 2'b10
reg [23:0] stored_bytes;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        stored_bytes <= 24'd0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle
                if (in[3] == 1'b1) begin
                    state <= 2'b01;
                    stored_bytes <= {in, 16'd0};
                end
            end
            2'b01: begin // byte1
                state <= 2'b10;
                stored_bytes <= {in, stored_bytes[15:0]};
            end
            2'b10: begin // byte2
                state <= 2'b00;
                stored_bytes <= {in, stored_bytes[23:8]};
                done <= 1'b1;
            end
            default: begin
                done <= 1'b0;
            end
        endcase
    end
end

assign out_bytes = (done)? stored_bytes : 24'd0;

endmodule