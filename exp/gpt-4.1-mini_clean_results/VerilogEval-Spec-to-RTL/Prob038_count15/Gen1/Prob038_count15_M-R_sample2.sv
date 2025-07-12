module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] next_q;

    // Combinational logic to determine next state
    always @(*) begin
        if (reset) begin
            next_q = 4'd0;
        end else begin
            next_q = q + 1;
        end
    end

    // Sequential logic to update state on rising clock edge
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule