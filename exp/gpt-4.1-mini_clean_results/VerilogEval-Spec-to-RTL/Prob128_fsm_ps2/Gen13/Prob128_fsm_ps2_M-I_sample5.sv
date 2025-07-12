module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    localparam COUNT_WIDTH = 2;
    localparam COUNT_MAX = 2'd2;

    reg [COUNT_WIDTH-1:0] count;

    // done is asserted when count == 2, meaning 3rd byte received
    assign done = (count == COUNT_MAX);

    always @(posedge clk) begin
        if (reset) begin
            count <= {COUNT_WIDTH{1'b0}};
        end else begin
            case (count)
                {COUNT_WIDTH{1'b0}}: begin
                    if (in[3])
                        count <= 2'd1;
                end
                COUNT_MAX: begin
                    // after done, reset count to 0
                    count <= 2'd0;
                end
                default: begin
                    count <= count + 1'b1;
                end
            endcase
        end
    end

endmodule