module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    reg [1:0] count;
    reg done_reg;

    // State update: synchronous with reset
    always @(posedge clk) begin
        if (reset)
            count <= 2'd0;
        else begin
            case (count)
                2'd0: count <= (in[3]) ? 2'd1 : 2'd0;
                2'd1: count <= 2'd2;
                2'd2: count <= 2'd0;
                default: count <= 2'd0;
            endcase
        end
    end

    // done asserted for one cycle immediately after third byte received
    // i.e. when count was 2 in the previous cycle, done is asserted this cycle
    always @(posedge clk) begin
        if (reset)
            done_reg <= 1'b0;
        else
            done_reg <= (count == 2'd2);
    end

    assign done = done_reg;

endmodule