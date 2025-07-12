module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // internal register to hold the current state

// apply Rule 90 on each clock cycle
always @(posedge clk) begin
    if (load) begin
        // load data into the register
        q_reg <= data;
    end else begin
        // apply Rule 90
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            if (i == 0) begin
                // left boundary
                left = 1'b0;
            end else begin
                left = q_reg[i - 1];
            end

            center = q_reg[i];

            if (i == 511) begin
                // right boundary
                right = 1'b0;
            end else begin
                right = q_reg[i + 1];
            end

            // compute the next state using the rules of Rule 90
            q_reg[i] <= left ^ right;
        end
    end
end

// assign output
assign q = q_reg;

endmodule