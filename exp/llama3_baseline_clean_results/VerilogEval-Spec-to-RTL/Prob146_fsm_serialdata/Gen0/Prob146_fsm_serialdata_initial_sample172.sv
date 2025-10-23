module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg;
reg [3:0] counter_reg;
reg [7:0] data_reg;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 0;
        counter_reg <= 0;
        data_reg <= 8'b0;
        out_byte_reg <= 8'b0;
        done_reg <= 0;
    end else begin
        case (state_reg)
            0: begin // IDLE
                if (!in) begin // Start bit detected
                    state_reg <= 1;
                    counter_reg <= 1;
                    data_reg[0] <= 1'b0;
                end
            end
            1: begin // RECEIVE
                data_reg <= {data_reg[6:0], in};
                counter_reg <= counter_reg + 1;
                if (counter_reg == 8) begin
                    state_reg <= 2;
                end
            end
            2: begin // STOP
                if (in) begin // Stop bit detected
                    state_reg <= 0;
                    out_byte_reg <= data_reg;
                    done_reg <= 1;
                end
            end
            default: begin
                state_reg <= 0;
            end
        endcase
        if (state_reg == 0 && counter_reg > 0) begin
            done_reg <= 0;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule