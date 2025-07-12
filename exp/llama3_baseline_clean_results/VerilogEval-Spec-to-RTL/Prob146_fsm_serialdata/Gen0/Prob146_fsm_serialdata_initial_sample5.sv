module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [2:0] state_next;
reg [7:0] data_counter;
reg [7:0] data_reg;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 0;
        data_counter <= 0;
        data_reg <= 0;
        out_byte_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state_reg)
            0: begin // IDLE
                if (~in) begin // start bit detected
                    state_reg <= 1;
                end else begin
                    state_reg <= 0;
                end
            end
            1: begin // START
                state_reg <= 2; // go to data state
                data_counter <= 0; // reset data counter
            end
            2: begin // DATA
                if (data_counter == 8) begin
                    state_reg <= 3; // go to stop state
                end else begin
                    data_reg <= {data_reg[6:0], in}; // shift data in
                    data_counter <= data_counter + 1; // increment data counter
                    state_reg <= 2; // stay in data state
                end
            end
            3: begin // STOP
                if (in) begin // stop bit detected
                    state_reg <= 0; // go back to idle state
                    out_byte_reg <= data_reg; // output data
                    done_reg <= 1; // assert done
                end else begin
                    state_reg <= 3; // stay in stop state
                end
            end
            default: state_reg <= 0; // default to idle state
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done_reg <= 0;
    end else if (state_reg == 3 && in) begin // if in stop state and stop bit detected
        done_reg <= 1; // assert done
    end else begin
        done_reg <= 0; // deassert done
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule