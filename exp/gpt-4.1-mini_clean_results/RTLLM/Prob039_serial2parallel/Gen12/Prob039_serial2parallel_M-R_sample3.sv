module serial2parallel (
    input             clk,
    input             rst_n,
    input             din_serial,
    input             din_valid,
    output     [7:0]  dout_parallel,
    output            dout_valid
);

    localparam IDLE  = 1'b0;
    localparam SHIFT = 1'b1;

    reg [7:0] shift_reg;
    reg [3:0] bit_count;
    reg       state;
    reg       valid_reg;

    always @(posedge clk) begin
        if (!rst_n) begin
            state      <= IDLE;
            shift_reg  <= 8'd0;
            bit_count  <= 4'd0;
            valid_reg  <= 1'b0;
        end else begin
            valid_reg <= 1'b0; // default: dout_valid low unless set below
            case(state)
                IDLE: begin
                    if (din_valid) begin
                        // Insert the first bit at MSB (shift right and put new bit in MSB)
                        shift_reg <= {din_serial, shift_reg[7:1]};
                        bit_count <= 4'd1;
                        state     <= SHIFT;
                    end
                end
                SHIFT: begin
                    if (din_valid) begin
                        // Shift right and insert new serial bit at MSB
                        shift_reg <= {din_serial, shift_reg[7:1]};
                        bit_count <= bit_count + 1'b1;
                        if (bit_count == 4'd7) begin
                            valid_reg <= 1'b1; // Output valid after receiving 8 bits
                            bit_count <= 4'd0;
                            state     <= IDLE;
                        end
                    end
                end
            endcase
        end
    end

    assign dout_parallel = shift_reg;
    assign dout_valid    = valid_reg;

endmodule