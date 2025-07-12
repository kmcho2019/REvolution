module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] count;     // count: 0 = searching, 1-3 = byte count
    reg [23:0] shift_reg;
    reg load_en;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            shift_reg <= 24'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
            load_en <= 1'b0;
        end else begin
            done <= 1'b0; // default no done
            load_en <= 1'b0;

            case (count)
                2'd0: begin
                    // Searching for start byte where in[3] == 1
                    if (in[3]) begin
                        // Load start byte into MSB of shift_reg, clear lower bytes
                        shift_reg <= {in, 16'd0};
                        count <= 2'd1;
                    end
                end
                2'd1: begin
                    // Shift in second byte
                    shift_reg <= {shift_reg[15:0], in};
                    count <= 2'd2;
                end
                2'd2: begin
                    // Shift in third byte
                    shift_reg <= {shift_reg[15:0], in};
                    out_bytes <= {shift_reg[15:0], in};
                    done <= 1'b1;
                    count <= 2'd0; // Go back to searching
                end
                default: count <= 2'd0;
            endcase
        end
    end

endmodule