module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    reg [7:0] out_byte_reg;
    reg done_reg;

    reg [2:0] state_reg;  // 0: IDLE, 1: DATA, 2: STOP, 3: ERROR
    reg [3:0] count_reg;  // counter for data bits
    reg [7:0] data_reg;   // register to store the data bits

    always @(posedge clk) begin
        if (reset) begin
            state_reg <= 3'b000; // IDLE
            count_reg <= 4'b0000;
            data_reg <= 8'b0;
            out_byte_reg <= 8'b0;
            done_reg <= 1'b0;
        end else begin
            case (state_reg)
                3'b000: begin // IDLE
                    if (~in) begin // start bit detected
                        state_reg <= 3'b001; // move to DATA state
                        count_reg <= 4'b0000;
                        data_reg <= 8'b0;
                    end
                end
                3'b001: begin // DATA
                    count_reg <= count_reg + 1;
                    data_reg <= {data_reg[6:0], in};
                    if (count_reg == 4'd8) begin
                        state_reg <= 3'b010; // move to STOP state
                    end
                end
                3'b010: begin // STOP
                    if (in) begin // stop bit correct
                        state_reg <= 3'b000; // move to IDLE state
                        out_byte_reg <= data_reg;
                        done_reg <= 1'b1;
                    end else begin
                        state_reg <= 3'b011; // move to ERROR state
                    end
                end
                3'b011: begin // ERROR
                    if (in) begin // stop bit detected
                        state_reg <= 3'b000; // move to IDLE state
                    end
                end
            endcase
        end
    end

    assign out_byte = out_byte_reg;
    assign done = done_reg;

endmodule