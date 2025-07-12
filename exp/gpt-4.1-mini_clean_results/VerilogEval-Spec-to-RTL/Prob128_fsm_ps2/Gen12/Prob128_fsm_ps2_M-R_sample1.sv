module TopModule(
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

    reg [1:0] count, next_count;
    reg       done_reg;

    // Combinational logic for next state and done signal
    always @(*) begin
        done_reg = 1'b0;
        next_count = count;

        if (count == 2'd0) begin
            // Waiting for first byte with in[3] == 1
            if (in[3])
                next_count = 2'd1;
        end else if (count == 2'd2) begin
            // Received third byte, signal done and reset count
            done_reg = 1'b1;
            next_count = 2'd0;
        end else begin
            // Count bytes 2 and 3
            next_count = count + 1'b1;
        end
    end

    // Sequential logic: state update and synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done_reg <= 1'b0;
        end else begin
            count <= next_count;
            done_reg <= done_reg;
        end
    end

    assign done = done_reg;

endmodule