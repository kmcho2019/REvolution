module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [1:0] count;
    wire      in_start_byte;
    wire      msg_active;

    assign in_start_byte = in[3];
    assign msg_active    = (count != 2'd0);

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done  <= 1'b0;
        end else begin
            done <= 1'b0; // default clear done each cycle

            if (count == 2'd0) begin
                // Waiting for start byte (in[3]==1)
                if (in_start_byte) begin
                    count <= 2'd1;
                end
            end else begin
                // Inside message: bytes 2 and 3
                if (count == 2'd2) begin
                    done  <= 1'b1;   // signal done immediately after third byte
                    count <= 2'd0;  // reset to wait for next start byte
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule