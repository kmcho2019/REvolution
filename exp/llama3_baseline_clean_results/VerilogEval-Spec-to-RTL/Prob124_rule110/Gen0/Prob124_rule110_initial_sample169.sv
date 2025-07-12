module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // internal register for current state

// load data into q_reg when load is high
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // calculate next state
        for (int i = 0; i < 512; i++) begin
            // handle boundary conditions
            wire left  = (i == 0) ? 0 : q_reg[i-1];
            wire right = (i == 511) ? 0 : q_reg[i+1];
            wire center = q_reg[i];

            // apply Rule 110
            reg next_state;
            if (left == 1 && center == 1 && right == 1) begin
                next_state = 0;
            end else if (left == 1 && center == 1 && right == 0) begin
                next_state = 1;
            end else if (left == 1 && center == 0 && right == 1) begin
                next_state = 1;
            end else if (left == 1 && center == 0 && right == 0) begin
                next_state = 0;
            end else if (left == 0 && center == 1 && right == 1) begin
                next_state = 1;
            end else if (left == 0 && center == 1 && right == 0) begin
                next_state = 1;
            end else if (left == 0 && center == 0 && right == 1) begin
                next_state = 1;
            end else begin // left == 0 && center == 0 && right == 0
                next_state = 0;
            end

            // update q_reg
            q_reg[i] <= next_state;
        end
    end
end

// output current state
assign q = q_reg;

endmodule