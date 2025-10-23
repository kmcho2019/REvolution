module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // 3-bit counter for consecutive ones count (0 to 6)
    reg [2:0] ones_count, next_ones_count;

    // Signals for detected conditions (combinational)
    wire discard_condition;
    wire flag_condition;
    wire error_condition;

    // Compute next count
    always @(*) begin
        if (in) begin
            // Increment count if less than 7, else saturate at 7 (error)
            if (ones_count < 3'd7)
                next_ones_count = ones_count + 3'd1;
            else
                next_ones_count = 3'd7;
        end else begin
            // Reset count on zero input
            next_ones_count = 3'd0;
        end
    end

    // Detect conditions according to HDLC rules:
    // (1) discard inserted zero after 5 ones: when current count=5 and input=0 (means last was zero after five ones)
    assign discard_condition = (ones_count == 3'd5) && (in == 1'b0);
    // (2) flag: six ones followed by zero
    assign flag_condition    = (ones_count == 3'd6) && (in == 1'b0);
    // (3) error: seven or more ones (count == 7)
    assign error_condition   = (ones_count == 3'd7);

    // Sequential logic: update count and outputs on clk edge
    always @(posedge clk) begin
        if (reset) begin
            ones_count <= 3'd0;
            disc       <= 1'b0;
            flag       <= 1'b0;
            err        <= 1'b0;
        end else begin
            ones_count <= next_ones_count;
            // Moore outputs asserted for one cycle after detection
            disc       <= discard_condition;
            flag       <= flag_condition;
            err        <= error_condition;
        end
    end

endmodule