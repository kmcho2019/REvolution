module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [10:0] state; // [10] = tc flag, [9:0] = counter

    always @(posedge clk) begin
        if (load) begin
            state <= {1'b0, data}; // clear tc flag, load counter
        end else begin
            if (state[10] == 0) begin // not terminal count yet
                if (state[9:0] == 10'd1) begin
                    state <= {1'b1, 10'd0}; // reached zero, set tc flag
                end else if (state[9:0] != 0) begin
                    state <= {1'b0, state[9:0] - 1}; // decrement counter
                end else begin
                    // counter zero but tc flag not set yet (edge case)
                    state <= {1'b1, 10'd0};
                end
            end
            // if tc flag set, hold state until load
        end
    end

    assign tc = state[10];

endmodule