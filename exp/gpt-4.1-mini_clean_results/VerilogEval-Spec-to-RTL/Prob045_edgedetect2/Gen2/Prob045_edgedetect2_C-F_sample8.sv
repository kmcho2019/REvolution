module TopModule (
    input        clk,
    input        rst_n,       // active-low asynchronous reset
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prev_in <= 8'b0;
            anyedge <= 8'b0;
        end else begin
            anyedge <= prev_in ^ in;  // detect edges from previous input
            prev_in <= in;            // register current input for next cycle
        end
    end

endmodule