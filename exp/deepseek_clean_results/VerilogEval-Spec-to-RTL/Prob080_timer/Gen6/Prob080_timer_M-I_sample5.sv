module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire clk_enable = !tc || load;
    wire gated_clk = clk & clk_enable;

    always @(posedge gated_clk) begin
        if (load) begin
            counter <= data;
        end else begin
            counter <= counter - |counter; // Decrement only if not zero
        end
    end

    assign tc = ~|counter; // NOR reduction for zero detection

endmodule