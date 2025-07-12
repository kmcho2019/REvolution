module TopModule(
    input        clk,
    input        reset,  // synchronous active high
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    reg [1:0] count;       // counts bytes received in current message (0 to 3)
    reg [23:0] shift_reg;  // holds collected bytes

    always @(posedge clk) begin
        if (reset) begin
            count     <= 2'd0;
            shift_reg <= 24'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0;
            if (count == 2'd0) begin
                // waiting for start byte with in[3]==1
                if (in[3]) begin
                    shift_reg <= {16'd0, in};
                    count <= 2'd1;
                end
            end else if (count < 2'd3) begin
                // shift in next byte
                shift_reg <= {shift_reg[15:0], in};
                count <= count + 1;
                if (count == 2'd2) begin
                    // After receiving 3rd byte (count will become 3 next)
                    out_bytes <= {shift_reg[15:0], in};
                    done <= 1'b1;
                    count <= 2'd0;  // reset to wait for next message
                end
            end
        end
    end

endmodule