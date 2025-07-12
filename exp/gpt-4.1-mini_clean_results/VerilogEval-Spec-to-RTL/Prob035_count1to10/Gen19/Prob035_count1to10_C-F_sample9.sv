module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    reg [3:0] count;
    reg [3:0] next_count;

    // Next state logic: if count == 9, wrap to 0; else increment
    always @(*) begin
        if (count == 4'd9)
            next_count = 4'd0;
        else
            next_count = count + 1'b1;
    end

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset)
            count <= 4'd0; // internal 0 means output 1
        else
            count <= next_count;
    end

    // Output logic: output count + 1
    always @(*) begin
        q = count + 1'b1;
    end

endmodule