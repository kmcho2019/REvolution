module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    // Individual flip-flop declarations
    reg ff0, ff1, ff2, ff3;

    // Shift connections between flip-flops
    wire d1 = ff0;
    wire d2 = ff1;
    wire d3 = ff2;

    // Output assignment
    assign out = ff3;

    // Flip-flop implementations with synchronous reset
    always @(posedge clk) begin
        if (!resetn) begin
            ff0 <= 1'b0;
        end else begin
            ff0 <= in;
        end
    end

    always @(posedge clk) begin
        if (!resetn) begin
            ff1 <= 1'b0;
        end else begin
            ff1 <= d1;
        end
    end

    always @(posedge clk) begin
        if (!resetn) begin
            ff2 <= 1'b0;
        end else begin
            ff2 <= d2;
        end
    end

    always @(posedge clk) begin
        if (!resetn) begin
            ff3 <= 1'b0;
        end else begin
            ff3 <= d3;
        end
    end

endmodule