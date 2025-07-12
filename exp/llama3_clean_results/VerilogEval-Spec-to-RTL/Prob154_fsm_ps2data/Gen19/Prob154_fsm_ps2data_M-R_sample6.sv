module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [2:0] state;
reg [2:0] next_state;
reg [23:0] next_out_bytes;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b001;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        out_bytes <= next_out_bytes;
        done <= (state == 3'b100);
    end
end

always @(*) begin
    case (state)
        3'b001: begin
            if (in[3] == 1'b1) begin
                next_state <= 3'b010;
                next_out_bytes <= {in, 16'b0};
            end else begin
                next_state <= 3'b001;
                next_out_bytes <= out_bytes;
            end
        end
        3'b010: begin
            next_state <= 3'b100;
            next_out_bytes <= {out_bytes[15:0], in};
        end
        3'b100: begin
            next_state <= 3'b001;
            next_out_bytes <= {out_bytes[7:0], in, 8'b0};
        end
        default: begin
            next_state <= 3'b001;
            next_out_bytes <= out_bytes;
        end
    endcase
end

endmodule