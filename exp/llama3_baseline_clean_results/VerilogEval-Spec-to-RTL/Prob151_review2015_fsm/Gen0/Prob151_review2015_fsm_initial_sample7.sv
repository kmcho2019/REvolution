module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state;
reg [3:0] shift_register;
reg [3:0] shift_counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        shift_register <= 4'b0000;
        shift_counter <= 4'b0000;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (shift_register == 4'b1101) begin
                    state <= 2'b01;
                    shift_counter <= 4'b0001;
                end else begin
                    shift_register <= {data, shift_register[3:1]};
                end
            end
            2'b01: begin // SHIFT
                if (shift_counter == 4'b1000) begin
                    state <= 2'b10;
                end else begin
                    shift_counter <= shift_counter + 1'b1;
                end
            end
            2'b10: begin // COUNT
                if (done_counting) begin
                    state <= 2'b11;
                end
            end
            2'b11: begin // DONE
                if (ack) begin
                    state <= 2'b00;
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00: begin // IDLE
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b0;
        end
        2'b01: begin // SHIFT
            shift_ena = 1'b1;
            counting = 1'b0;
            done = 1'b0;
        end
        2'b10: begin // COUNT
            shift_ena = 1'b0;
            counting = 1'b1;
            done = 1'b0;
        end
        2'b11: begin // DONE
            shift_ena = 1'b0;
            counting = 1'b0;
            done = 1'b1;
        end
    endcase
end

endmodule