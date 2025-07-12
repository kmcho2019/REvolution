module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [2:0] state; // Idle, Start, Data, Stop
reg [7:0] data_byte;
reg [2:0] bit_counter;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Idle
        bit_counter <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (!in) begin
                    state <= 1; // Start
                end
            end
            1: begin // Start
                state <= 2; // Data
                bit_counter <= 1;
                data_byte[0] <= in;
            end
            2: begin // Data
                if (bit_counter < 8) begin
                    data_byte[bit_counter] <= in;
                    bit_counter <= bit_counter + 1;
                end else begin
                    state <= 3; // Stop
                end
            end
            3: begin // Stop
                if (in) begin
                    done_reg <= 1;
                    out_byte <= data_byte;
                    state <= 0; // Idle
                    bit_counter <= 0;
                end
            end
        endcase
    end
end

assign done = done_reg;

always @(posedge clk) begin
    if (reset) begin
        done_reg <= 0;
    end else if (state == 3 && in) begin
        done_reg <= 1;
    end else begin
        done_reg <= 0;
    end
end

endmodule