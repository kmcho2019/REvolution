module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    // Individual flip-flop declarations
    reg ff0, ff1, ff2, ff3;

    // First stage flip-flop
    always @(posedge clk) begin
        if (!resetn) ff0 <= 1'b0;
        else        ff0 <= in;
    end

    // Second stage flip-flop
    always @(posedge clk) begin
        if (!resetn) ff1 <= 1'b0;
        else        ff1 <= ff0;
    end

    // Third stage flip-flop
    always @(posedge clk) begin
        if (!resetn) ff2 <= 1'b0;
        else        ff2 <= ff1;
    end

    // Fourth stage flip-flop
    always @(posedge clk) begin
        if (!resetn) ff3 <= 1'b0;
        else        ff3 <= ff2;
    end

    // Output assignment
    assign out = ff3;

endmodule