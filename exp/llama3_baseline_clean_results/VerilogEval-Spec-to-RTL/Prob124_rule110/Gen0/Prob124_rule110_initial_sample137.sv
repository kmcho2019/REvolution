module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_state;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

    always @(*) begin
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                // Left boundary is always 0
                if (q[i] == 1'b1 && q[i+1] == 1'b1) begin
                    next_state[i] = 1'b0;
                end else if (q[i] == 1'b1 && q[i+1] == 1'b0) begin
                    next_state[i] = 1'b1;
                end else if (q[i] == 1'b0 && q[i+1] == 1'b1) begin
                    next_state[i] = 1'b1;
                end else begin
                    next_state[i] = 1'b0;
                end
            end else if (i == 511) begin
                // Right boundary is always 0
                if (q[i-1] == 1'b1 && q[i] == 1'b1) begin
                    next_state[i] = 1'b1;
                end else if (q[i-1] == 1'b1 && q[i] == 1'b0) begin
                    next_state[i] = 1'b1;
                end else if (q[i-1] == 1'b0 && q[i] == 1'b1) begin
                    next_state[i] = 1'b1;
                end else begin
                    next_state[i] = 1'b0;
                end
            end else begin
                if (q[i-1] == 1'b1 && q[i] == 1'b1 && q[i+1] == 1'b1) begin
                    next_state[i] = 1'b0;
                end else if (q[i-1] == 1'b1 && q[i] == 1'b1 && q[i+1] == 1'b0) begin
                    next_state[i] = 1'b1;
                end else if (q[i-1] == 1'b1 && q[i] == 1'b0 && q[i+1] == 1'b1) begin
                    next_state[i] = 1'b1;
                end else if (q[i-1] == 1'b1 && q[i] == 1'b0 && q[i+1] == 1'b0) begin
                    next_state[i] = 1'b0;
                end else if (q[i-1] == 1'b0 && q[i] == 1'b1 && q[i+1] == 1'b1) begin
                    next_state[i] = 1'b1;
                end else if (q[i-1] == 1'b0 && q[i] == 1'b1 && q[i+1] == 1'b0) begin
                    next_state[i] = 1'b1;
                end else if (q[i-1] == 1'b0 && q[i] == 1'b0 && q[i+1] == 1'b1) begin
                    next_state[i] = 1'b1;
                end else begin
                    next_state[i] = 1'b0;
                end
            end
        end
    end

endmodule