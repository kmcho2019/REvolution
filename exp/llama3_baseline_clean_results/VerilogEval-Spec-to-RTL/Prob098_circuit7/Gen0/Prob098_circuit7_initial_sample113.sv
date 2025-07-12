module TopModule(
    input clk,
    input a,
    output reg q
);

    reg q_initial_set = 1'b0; // Flag to track the first clock edge

    always @(posedge clk) begin
        if (!q_initial_set) begin // First rising clock edge
            q <= 1'b1;
            q_initial_set <= 1'b1;
        end else if (a) begin // If a is 1, toggle q
            q <= ~q;
        end
    end

endmodule