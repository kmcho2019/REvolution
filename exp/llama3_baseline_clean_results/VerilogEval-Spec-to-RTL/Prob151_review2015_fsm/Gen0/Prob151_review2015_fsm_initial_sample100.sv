module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [1:0] state;
reg [3:0] shift_reg;
reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        shift_reg <= 4'b0000;
        count <= 4'b0000;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (shift_reg == 4'b1101) begin
                    state <= 2'b01;
                    shift_ena <= 1'b1;
                    shift_reg <= {data, shift_reg[3:1]};
                end else begin
                    shift_reg <= {data, shift_reg[3:1]};
                end
            end
            2'b01: begin // SHIFT
                if (count == 4'b1111) begin
                    state <= 2'b10;
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                end else begin
                    count <= count + 1'b1;
                    shift_reg <= {data, shift_reg[3:1]};
                end
            end
            2'b10: begin // COUNT
                if (done_counting) begin
                    state <= 2'b11;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end
            2'b11: begin // DONE
                if (ack) begin
                    state <= 2'b00;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule