module TopModule (
    input clk,
    input d,
    output reg q
);

    reg clk_d;

    // Register previous clock value to detect rising edge manually
    always @(posedge clk or negedge clk) begin
        clk_d <= clk;
    end

    // On detected rising edge (clk=1 and previous clk=0), update q
    always @(clk or clk_d) begin
        if (clk && ~clk_d) begin
            q <= d;
        end
    end

endmodule