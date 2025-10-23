module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    reg [1:0] count; // 0 to 3 count of bytes collected

    always @(posedge clk) begin
        if (reset) begin
            count     <= 2'd0;
            done      <= 1'b0;
            out_bytes <= 24'd0;
        end else begin
            done <= 1'b0; // default done low

            case (count)
                2'd0: begin
                    // Waiting for start byte with in[3]=1
                    if (in[3]) begin
                        out_bytes <= {in, 16'd0}; // shift byte into upper 8 bits
                        count <= 2'd1;
                    end
                end
                2'd1, 2'd2: begin
                    // Shift in next byte: shift left 8 bits and insert in lower 8 bits
                    out_bytes <= {out_bytes[15:0], in};
                    count <= count + 1;
                end
                2'd3: begin
                    // Done after third byte received
                    done <= 1'b1;
                    count <= 2'd0;
                end
            endcase
        end
    end

endmodule