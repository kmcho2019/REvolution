module serial2parallel (
    input        clk,
    input        rst_n,
    input        din_serial,
    input        din_valid,
    output reg [7:0] dout_parallel,
    output reg       dout_valid
);

    // State definitions
    localparam IDLE = 1'b0,
               LOAD = 1'b1;

    reg state;
    reg [7:0] shift_reg;
    reg [3:0] bit_count;

    // State transition and counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= IDLE;
            bit_count  <= 4'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (din_valid) begin
                        state     <= LOAD;
                        bit_count <= 4'd0;
                    end
                end
                LOAD: begin
                    if (din_valid) begin
                        if (bit_count == 4'd7) begin
                            state     <= IDLE;
                            bit_count <= 4'd0;
                        end else begin
                            bit_count <= bit_count + 1'b1;
                        end
                    end
                end
            endcase
        end
    end

    // Shift register and output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg     <= 8'd0;
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
        end else begin
            dout_valid <= 1'b0;  // default deassert

            if (din_valid) begin
                // shift left and insert new bit at LSB
                shift_reg <= {shift_reg[6:0], din_serial};

                if (state == LOAD && bit_count == 4'd7) begin
                    dout_parallel <= {shift_reg[6:0], din_serial};
                    dout_valid    <= 1'b1;
                end
            end
        end
    end

endmodule