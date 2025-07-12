module TopModule (
    input  wire       clk,
    input  wire       reset,
    output reg [9:0]  q
);

    localparam MAX_COUNT = 10'd999;

    reg [9:0] next_q;
    wire upper_match;
    wire lower_match;
    wire is_max_count;

    assign upper_match = (q[9:7] == 3'b111);
    assign lower_match = (q[6:0] == 7'b1100111);
    assign is_max_count = upper_match & lower_match;

    // Combinational logic for next state
    always @(*) begin
        if (reset) begin
            next_q = 10'd0;
        end else if (is_max_count) begin
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