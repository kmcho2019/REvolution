module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output reg   done
);

    reg [2:0] shift;

    always @(posedge clk) begin
        if (reset) begin
            shift <= 3'd0;
            done  <= 1'b0;
        end else begin
            done <= 1'b0;

            // Detect start of message when not already in message
            if (shift == 3'd0) begin
                if (in[3])
                    shift <= 3'b001;
            end else begin
                shift <= {shift[1:0], 1'b1};
                if (shift == 3'b011) begin
                    done  <= 1'b1;
                    shift <= 3'd0;
                end
            end
        end
    end

endmodule