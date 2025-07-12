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
            done <= 1'b0; // default done de-assertion each cycle

            if (count == 2'd0) begin
                // Waiting for start byte where in[3] == 1
                if (start_byte)
                    count <= 2'd1;
            end else begin
                // Inside a message counting subsequent bytes
                if (count == 2'd2) begin
                    // Third byte received: pulse done and reset count
                    done  <= 1'b1;
                    count <= 2'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule