module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state according to Rule 110
            for (int i = 0; i < 512; i++) begin
                // Handle boundary conditions
                reg left, center, right;
                if (i == 0) begin
                    left = 1'b0;
                    center = q[i];
                    right = q[i + 1];
                end else if (i == 511) begin
                    left = q[i - 1];
                    center = q[i];
                    right = 1'b0;
                end else begin
                    left = q[i - 1];
                    center = q[i];
                    right = q[i + 1];
                end

                // Rule 110 logic
                if (left == 1'b1 && center == 1'b1 && right == 1'b1) begin
                    q[i] <= 1'b0;
                end else if (left == 1'b1 && center == 1'b1 && right == 1'b0) begin
                    q[i] <= 1'b1;
                end else if (left == 1'b1 && center == 1'b0 && right == 1'b1) begin
                    q[i] <= 1'b1;
                end else if (left == 1'b1 && center == 1'b0 && right == 1'b0) begin
                    q[i] <= 1'b0;
                end else if (left == 1'b0 && center == 1'b1 && right == 1'b1) begin
                    q[i] <= 1'b1;
                end else if (left == 1'b0 && center == 1'b1 && right == 1'b0) begin
                    q[i] <= 1'b1;
                end else if (left == 1'b0 && center == 1'b0 && right == 1'b1) begin
                    q[i] <= 1'b1;
                end else if (left == 1'b0 && center == 1'b0 && right == 1'b0) begin
                    q[i] <= 1'b0;
                end
            end
        end
    end

endmodule