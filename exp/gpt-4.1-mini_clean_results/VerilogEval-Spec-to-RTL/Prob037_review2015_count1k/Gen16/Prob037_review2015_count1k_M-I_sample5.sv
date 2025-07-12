module TopModule (
    input  wire       clk,
    input  wire       reset,
    output reg [9:0]  q
);

    localparam [9:0] MAX_COUNT = 10'd999;

    reg [9:0] next_q;

    // Combinational logic for next state
    always @(*) begin
        if (reset) begin
            next_q = 10'd0;
        end else if (q == MAX_COUNT) begin
            next_q = 10'd0;
        end else begin
            next_q = q + 10'd1;
        end
    end

    // Sequential logic for state update
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule