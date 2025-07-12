module TopModule(
    input         clk,
    input         reset,
    input  [7:0]  in,
    output [23:0] out_bytes,
    output        done
);

reg [1:0] current_state;
reg [23:0] out_bytes_reg;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 2'b00; // idle state
        out_bytes_reg <= 24'b0;
        done <= 1'b0;
    end else begin
        case (current_state)
            2'b00: begin // idle state
                if (in[3] == 1'b1) begin
                    out_bytes_reg[23:16] <= in;
                    current_state <= 2'b01; // byte1 state
                end
            end
            2'b01: begin // byte1 state
                out_bytes_reg[15:8] <= in;
                current_state <= 2'b10; // byte2 state
            end
            2'b10: begin // byte2 state
                out_bytes_reg[7:0] <= in;
                current_state <= 2'b11; // done state
                done <= 1'b1;
            end
            2'b11: begin // done state
                current_state <= 2'b00; // idle state
                done <= 1'b0;
            end
            default: begin
                current_state <= 2'b00; // idle state
            end
        endcase
    end
end

assign out_bytes = out_bytes_reg;

endmodule