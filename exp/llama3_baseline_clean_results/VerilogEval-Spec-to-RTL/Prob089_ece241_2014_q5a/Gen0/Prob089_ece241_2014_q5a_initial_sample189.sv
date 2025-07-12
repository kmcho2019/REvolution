module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // 0: idle, 1: running, 2: done
reg [31:0] input_num; // assuming max 32-bit input number
reg [31:0] complement; // 2's complement of input number
reg [31:0] ones_comp; // 1's complement of input number
reg started; // whether we have started processing input bits

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // idle state
        input_num <= 32'b0;
        complement <= 32'b0;
        ones_comp <= 32'b0;
        started <= 1'b0;
        z <= 1'b0;
    end else begin
        case (state)
            0: begin // idle state
                if (~areset) begin
                    state <= 1; // transition to running state
                    input_num <= 32'b0;
                    started <= 1'b0;
                end
            end
            1: begin // running state
                input_num <= {input_num[30:0], x}; // shift in input bit
                if (x == 1'b1 && ~started) begin
                    started <= 1'b1; // mark as started
                end
                if (started) begin
                    ones_comp <= {ones_comp[30:0], ~x}; // calculate 1's complement
                end
                if (areset) begin
                    state <= 0; // reset to idle state
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == 1 && started) begin
        complement <= ones_comp + 1'b1; // calculate 2's complement
        z <= complement[0]; // output 2's complement bit
    end else begin
        z <= 1'b0;
    end
end

endmodule