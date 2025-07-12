module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] count;
    wire      start_byte;

    assign start_byte = in[3];

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done  <= 1'b0;
        end else begin
            done <= 1'b0; // default done low every cycle

            if (count == 2'd0) begin
                // Waiting for start byte
                if (start_byte)
                    count <= 2'd1;
                // else remain in count 0
            end else begin
                // Inside a message: bytes 2 and 3
                if (count == 2'd2) begin
                    done  <= 1'b1;  // pulse done after third byte
                    count <= 2'd0;  // reset to wait for next message
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule