module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    reg [1:0] count;
    reg [23:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            count     <= 2'd0;
            done      <= 1'b0;
            out_bytes <= 24'd0;
            shift_reg <= 24'd0;
        end else begin
            done <= 1'b0; // default done low

            if (count == 2'd0) begin
                // Wait for start byte with in[3]=1
                if (in[3]) begin
                    // Load start byte into highest byte position
                    shift_reg <= {in, 16'd0};
                    count <= 2'd1;
                end
            end else begin
                // Shift in next byte at lower positions
                shift_reg <= {shift_reg[15:0], in};
                if (count == 2'd2) begin
                    // Third byte received, output message and done
                    out_bytes <= {shift_reg[15:0], in};
                    done <= 1'b1;
                    count <= 2'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule