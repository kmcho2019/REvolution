module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [1:0] cycle_count;
    reg done;

    assign shift_ena = !done && (cycle_count <= 2'd3);

    always @(posedge clk) begin
        if (reset) begin
            cycle_count <= 2'd0;
            done <= 1'b0;
        end else if (!done) begin
            if (cycle_count == 2'd3) begin
                done <= 1'b1;
            end else begin
                cycle_count <= cycle_count + 1;
            end
        end
    end

endmodule