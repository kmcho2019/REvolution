module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg [23:0] out_bytes,
    output reg       done
);

    reg [1:0] count;
    reg [23:0] msg_reg;

    always @(posedge clk) begin
        if (reset) begin
            count     <= 2'd0;
            done      <= 1'b0;
            out_bytes <= 24'd0;
            msg_reg   <= 24'd0;
        end else begin
            done <= 1'b0;  // default done low
            if (count == 2'd0) begin
                // Waiting for start byte with in[3]==1
                if (in[3]) begin
                    msg_reg <= {16'd0, in}; // load first byte at LSB
                    count <= 2'd1;
                end
            end else if (count == 2'd1 || count == 2'd2) begin
                msg_reg <= {msg_reg[15:0], in}; // shift left 8 bits, add new byte
                count <= count + 1;
            end else if (count == 2'd3) begin
                // Third byte received in previous cycle, output and done
                out_bytes <= msg_reg;
                done <= 1'b1;
                count <= 2'd0;
                msg_reg <= 24'd0;  // clear or prepare for next message
            end
        end
    end

endmodule