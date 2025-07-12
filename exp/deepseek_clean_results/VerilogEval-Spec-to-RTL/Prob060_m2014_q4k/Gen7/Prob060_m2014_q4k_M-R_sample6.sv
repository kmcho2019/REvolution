module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg ff0, ff1, ff2, ff3;
    wire d1, d2, d3;

    // Shift connections
    assign d1 = ff0;
    assign d2 = ff1;
    assign d3 = ff2;

    // Flip-flop implementations
    always @(posedge clk) begin
        if (!resetn) ff0 <= 1'b0;
        else         ff0 <= in;
    end

    always @(posedge clk) begin
        if (!resetn) ff1 <= 1'b0;
        else         ff1 <= d1;
    end

    always @(posedge clk) begin
        if (!resetn) ff2 <= 1'b0;
        else         ff2 <= d2;
    end

    always @(posedge clk) begin
        if (!resetn) ff3 <= 1'b0;
        else         ff3 <= d3;
    end

    assign out = ff3;

endmodule