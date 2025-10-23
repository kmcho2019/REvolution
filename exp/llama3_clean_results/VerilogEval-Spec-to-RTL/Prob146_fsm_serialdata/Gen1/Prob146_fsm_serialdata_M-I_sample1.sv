module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    reg [2:0] state; // Idle, Start, Data, Stop
    reg [2:0] data_count; // counter for data bits
    reg [7:0] shift_reg; // shift register for data bits

    always @(posedge clk) begin
        if (reset) begin
            state <= 0; // Idle
            done <= 0;
            data_count <= 0;
            out_byte <= 0;
        end else begin
            case (state)
                0: begin // Idle
                    if (!in) begin
                        state <= 1; // Start
                    end
                end
                1: begin // Start
                    shift_reg[0] <= in;
                    state <= 2; // Data
                    data_count <= 1;
                end
                2: begin // Data
                    shift_reg <= {shift_reg[6:0], in}; // shift in new bit
                    data_count <= data_count + 1;
                    if (data_count == 8) begin
                        state <= 3; // Stop
                    end
                end
                3: begin // Stop
                    if (in) begin
                        out_byte <= shift_reg; // output data byte
                        done <= 1;
                        state <= 0; // Idle
                    end
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if (state == 3) begin
            done <= 0;
        end
    end

endmodule