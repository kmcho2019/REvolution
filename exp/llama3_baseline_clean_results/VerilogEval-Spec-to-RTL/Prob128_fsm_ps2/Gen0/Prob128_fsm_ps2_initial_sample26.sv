module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state;
reg [1:0] next_state;
reg done_reg;
reg done_next;

always @(*) begin
    case(state)
        2'b00: begin // IDLE
            if(in[3]) begin
                next_state = 2'b01; // BYTE1
                done_next = 1'b0;
            end else begin
                next_state = 2'b00; // IDLE
                done_next = 1'b0;
            end
        end
        2'b01: begin // BYTE1
            next_state = 2'b10; // BYTE2
            done_next = 1'b0;
        end
        2'b10: begin // BYTE2
            next_state = 2'b11; // BYTE3
            done_next = 1'b0;
        end
        2'b11: begin // BYTE3
            next_state = 2'b00; // IDLE
            done_next = 1'b1;
        end
        default: begin
            next_state = 2'b00; // IDLE
            done_next = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00;
        done_reg <= 1'b0;
    end else begin
        state <= next_state;
        done_reg <= done_next;
    end
end

assign done = done_reg;

endmodule